require "rexml/streamlistener"
require "rexml/parsers/baseparser"
require "rexml/parsers/streamparser"
require "strscan"

require_relative "dataset"

module Datasets
  class CLDRPlurals < Dataset
    Locale = Struct.new(:name,
                        :rules)

    Rule = Struct.new(:count,
                      :condition,
                      :integer_samples,
                      :decimal_samples)

    def initialize
      super()
      @metadata.id = "cldr-plurals"
      @metadata.name = "CLDR language plural rules"
      @metadata.url = "https://raw.githubusercontent.com/unicode-org/cldr/master/common/supplemental/plurals.xml"
      @metadata.licenses = ["Unicode-DFS-2016"]
      @metadata.description = <<~DESCRIPTION
        Language plural rules in Unicode Common Locale Data Repository.
        See also: https://unicode-org.github.io/cldr-staging/charts/latest/supplemental/language_plural_rules.html
      DESCRIPTION
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      open_data do |input|
        catch do |abort_tag|
          listener = Listener.new(abort_tag, &block)
          parser = REXML::Parsers::StreamParser.new(input, listener)
          parser.parse
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "plurals.xml"
      download(data_path, @metadata.url)
      data_path.open do |input|
        yield(input)
      end
    end

    # Spec: https://unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules
    class Listener
      include REXML::StreamListener

      def initialize(abort_tag, &block)
        @abort_tag = abort_tag
        @block = block
        @tag_name_stack = []
      end

      def tag_start(name, attributes)
        @tag_name_stack.push(name)
        case name
        when "pluralRules"
          @locales = attributes["locales"].split
          @rules = []
        when "pluralRule"
          @rule = Rule.new(attributes["count"])
        end
      end

      def tag_end(name)
        case name
        when "pluralRules"
          @locales.each do |locale_name|
            @block.call(Locale.new(locale_name, @rules))
          end
        when "pluralRule"
          @rules << @rule
        end
        @tag_name_stack.pop
      end

      def text(data)
        case @tag_name_stack.last
        when "pluralRule"
          parse_plural_rule(data)
        end
      end

      private
      def parse_plural_rule(data)
        parser = RuleParser.new(@rule, data)
        parser.parse
      end
    end
    private_constant :Listener

    # Syntax: http://unicode.org/reports/tr35/tr35-numbers.html#Plural_rules_syntax
    class RuleParser
      def initialize(rule, data)
        @rule = rule
        @data = data
        @scanner = StringScanner.new(@data)
      end

      def parse
        @rule.condition = parse_condition
        skip_whitespaces
        if @scanner.scan(/@integer/)
          @rule.integer_samples = parse_sample_list
        end
        skip_whitespaces
        if @scanner.scan(/@decimal/)
          @rule.decimal_samples = parse_sample_list
        end
      end

      private
      def skip_whitespaces
        @scanner.skip(/\p{Pattern_White_Space}+/)
      end

      def parse_condition
        and_condition = parse_and_condition
        return nil if and_condition.nil?
        and_conditions = [and_condition]
        while parse_or
          and_conditions << parse_and_condition
        end
        if and_conditions.size == 1
          and_condition
        else
          [:or, *and_conditions]
        end
      end

      def parse_or
        skip_whitespaces
        @scanner.scan(/or/)
      end

      def parse_and_condition
        skip_whitespaces
        relation = parse_relation
        return nil if relation.nil?
        relations = [relation]
        while parse_and
          relations << parse_relation
        end
        if relations.size == 1
          relation
        else
          [:and, *relations]
        end
      end

      def parse_and
        skip_whitespaces
        @scanner.scan(/and/)
      end

      def parse_relation
        parse_is_relation or
          parse_in_relation or
          parse_within_relation
      end

      def parse_is_relation
        position = @scanner.pos
        skip_whitespaces
        expr = parse_expr
        unless parse_is
          @scanner.pos = position
          return nil
        end
        if parse_not
          operator = :is_not
        else
          operator = :is
        end
        value = parse_value
        if value.nil?
          raise Error, "no value for #{operator}: #{@scanner.inspect}"
        end
        [operator, expr, value]
      end

      def parse_is
        skip_whitespaces
        @scanner.scan(/is/)
      end

      def parse_not
        skip_whitespaces
        @scanner.scan(/not/)
      end

      def parse_in_relation
        position = @scanner.pos
        skip_whitespaces
        expr = parse_expr
        if parse_not
          if parse_in
            operator = :not_in
          else
            @scanner.ops = position
            return nil
          end
        elsif parse_in
          operator = :in
        elsif parse_equal
          operator = :equal
        elsif parse_not_equal
          operator = :not_equal
        else
          @scanner.pos = position
          return nil
        end
        range_list = parse_range_list
        [operator, expr, range_list]
      end

      def parse_in
        skip_whitespaces
        @scanner.scan(/in/)
      end

      def parse_equal
        skip_whitespaces
        @scanner.scan(/=/)
      end

      def parse_not_equal
        skip_whitespaces
        @scanner.scan(/!=/)
      end

      def parse_within_relation
        position = @scanner.pos
        skip_whitespaces
        expr = parse_expr
        have_not = parse_not
        unless parse_within
          @scanner.pos = position
          return nil
        end
        if have_not
          operator = :not_within
        else
          operator = :within
        end
        range_list = parse_range_list
        [operator, expr, range_list]
      end

      def parse_within
        skip_whitespaces
        @scanner.scan(/within/)
      end

      def parse_expr
        operand = parse_operand
        operator = parse_expr_operator
        if operator
          value = parse_value
          if value.nil?
            raise Error, "no value for #{operator}: #{@scanner.inspect}"
          end
          [operator, operand, value]
        else
          operand
        end
      end

      def parse_operand
        skip_whitespaces
        @scanner.scan(/[niftvwce]/)
      end

      def parse_expr_operator
        skip_whitespaces
        if @scanner.scan(/(?:mod|%)/)
          :mod
        else
          nil
        end
      end

      def parse_range_list
        ranges = [parse_range || parse_value]
        loop do
          skip_whitespaces
          break unless @scanner.scan(/,/)
          ranges << (parse_range || parse_value)
        end
        ranges
      end

      def parse_range
        position = @scanner.pos
        range_start = parse_value
        skip_whitespaces
        unless @scanner.scan(/\.\./)
          @scanner.pos = position
          return nil
        end
        range_end = parse_value
        range_start..range_end
      end

      def parse_value
        skip_whitespaces
        value = @scanner.scan(/\d+/)
        return nil if value.nil?
        Integer(value, 10)
      end

      def parse_sample_list
        samples = [parse_sample_range]
        loop do
          position = @scanner.pos
          skip_whitespaces
          break unless @scanner.scan(/,/)
          sample_range = parse_sample_range
          unless sample_range
            @scanner.pos = position
            break
          end
          samples << sample_range
        end
        skip_whitespaces
        if @scanner.scan(/,/)
          skip_whitespaces
          # U+2026 HORIZONTAL ELLIPSIS
          unless @scanner.scan(/\u2026|\.\.\./)
            raise Error, "no ellipsis: #{@scanner.inspect}"
          end
          samples << :elipsis
        end
        samples
      end

      def parse_sample_range
        value = parse_sample_value
        return nil if value.nil?
        skip_whitespaces
        if @scanner.scan(/~/)
          range_end = parse_sample_value
          value..range_end
        else
          value
        end
      end

      def parse_sample_value
        value = parse_value
        return nil if value.nil?
        if @scanner.scan(/\./)
          skip_whitespaces
          decimal = @scanner.scan(/[0-9]+/)
          if decimal.nil?
            raise Error, "no decimal: #{@scanner.inspect}"
          end
          value += Float("0.#{decimal}")
          skip_whitespaces
        end
        if @scanner.scan(/[ce]/)
          # Workardoun for a spec bug. "e1" should be accepted.
          #
          # Spec:
          #   sampleValue     = value ('.' digit+)? ([ce] digitPos digit+)?
          #   digit           = [0-9]
          #   digitPos        = [1-9]
          e = @scanner.scan(/[1-9][0-9]*/)
          value *= 10 * Integer(e, 10)
        end
        value
      end
    end
    private_constant :RuleParser
  end
end
