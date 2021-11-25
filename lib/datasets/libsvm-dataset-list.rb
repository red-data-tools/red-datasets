require "rexml/streamlistener"
require "rexml/parsers/baseparser"
require "rexml/parsers/streamparser"

require_relative "dataset"

module Datasets
  class LIBSVMDatasetList < Dataset
    File = Struct.new(:name,
                      :url,
                      :note)
    class Record < Struct.new(:name,
                              :source,
                              :preprocessing,
                              :n_classes,
                              :n_data,
                              :n_features,
                              :files)
      def to_h
        hash = super
        hash[:files] = hash[:files].collect(&:to_h)
        hash
      end
    end

    def initialize
      super()
      @metadata.id = "libsvm-dataset-list"
      @metadata.name = "LIBSVM dataset list"
      @metadata.url = "https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/"
      @metadata.licenses = ["BSD-3-Clause"]
      @metadata.description = lambda do
        extract_description
      end
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      open_data do |input|
        catch do |abort_tag|
          listener = IndexListener.new(abort_tag) do |href, record|
            parse_detail(href, record)
            yield(record)
          end
          parser = REXML::Parsers::StreamParser.new(input, listener)
          parser.parse
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "index.html"
      download(data_path, @metadata.url)
      data_path.open do |input|
        yield(input)
      end
    end

    def extract_description
      open_data do |input|
        description = []
        catch do |abort_tag|
          listener = DescriptionListener.new(abort_tag, description)
          parser = REXML::Parsers::StreamParser.new(input, listener)
          parser.parse
        end
        description.join("\n\n")
      end
    end

    def extract_text(element)
      texts = REXML::XPath.match(element, ".//text()")
      texts.join("").gsub(/[ \t\n]+/, " ").strip
    end

    def open_detail(detail)
      data_path = cache_dir_path + detail
      download(data_path, @metadata.url + detail)
      data_path.open do |input|
        yield(input)
      end
    end

    def parse_detail(href, record)
      path, id = href.split("#")
      open_detail(path) do |input|
        catch do |abort_tag|
          listener = DetailListener.new(abort_tag, id, @metadata.url, record)
          parser = REXML::Parsers::StreamParser.new(input, listener)
          parser.parse
        end
      end
    end

    class IndexListener
      include REXML::StreamListener

      def initialize(abort_tag, &block)
        @abort_tag = abort_tag
        @block = block
        @row = nil
        @in_td = false
      end

      def tag_start(name, attributes)
        case name
        when "tr"
          @row = []
        when "td"
          @in_td = true
          @row << {:text => ""}
        when "a"
          @row.last[:href] = attributes["href"] if @in_td
        end
      end

      def tag_end(name)
        case name
        when "table"
          throw(@abort_tag)
        when "tr"
          name_column = @row[0]
          return unless name_column
          record = Record.new
          record.name = name_column[:text]
          record.files = []
          @block.call(name_column[:href], record)
        when "td"
          @in_td = false
        end
      end

      def text(data)
        @row.last[:text] << data if @in_td
      end
    end

    class DetailListener
      include REXML::StreamListener

      def initialize(abort_tag, id, base_url, record)
        @abort_tag = abort_tag
        @id = id
        @base_url = base_url
        @record = record
        @in_target = false
        @target_li_level = nil
        @key = nil
        @data = nil
        @file = nil
      end

      def tag_start(name, attributes)
        if @in_target
          case name
          when "li"
            @target_li_level += 1
            case @target_li_level
            when 0
              @key = nil
              @data = nil
              @file = nil
            when 1
              @file = File.new
            end
          when "a"
            @file.url = @base_url + attributes["href"] if @file
          end
        else
          if attributes["name"] == @id
            @in_target = true
            @target_li_level = -1
          end
        end
      end

      def tag_end(name)
        if @in_target
          case name
          when "ul"
            throw(@abort_tag) if @target_li_level == -1
          when "li"
            case @target_li_level
            when 0
              if @key
                data = @data
                data = data.gsub(/[ \t\n]+/, " ").strip if data.is_a?(String)
                @record[@key] = data
              end
            when 1
              @data << @file if @data and @file
            end
            @target_li_level -= 1
          end
        end
      end

      def text(data)
        case @target_li_level
        when 0
          if @key
            @data << data
          else
            case data.gsub(/[ \t\n]+/, " ")
            when /\ASource: /
              @key = :source
              @data = $POSTMATCH
            when /\APreprocessing: /
              @key = :preprocessing
              @data = $POSTMATCH
            when /\A\# of classes: (\d+)/
              @key = :n_classes
              @data = Integer($1, 10)
            when /\A\# of data: ([\d,]+)/
              @key = :n_data
              @data = Integer($1.gsub(/,/, ""), 10)
            when /\A\# of features: ([\d,]+)/
              @key = :n_features
              @data = Integer($1.gsub(/,/, ""), 10)
            when /\AFiles:/
              @key = :files
              @data = []
            end
          end
        when 1
          if @file.name.nil?
            @file.name = data
          else
            @file.note = data.strip.gsub(/[()]/, "")
          end
        end
      end
    end

    class DescriptionListener
      include REXML::StreamListener

      def initialize(abort_tag, description)
        @abort_tag = abort_tag
        @description = description
        @in_content = false
        @p = nil
      end

      def tag_start(name, attributes)
        case name
        when "p"
          @in_content = true
          @p = []
        when "br"
          @description << @p.join(" ")
          @p = []
        when "hr"
          throw(@abort_tag)
        end
      end

      def tag_end(name)
        case name
        when "p"
          @description << @p.join(" ")
        end
      end

      def text(data)
        return unless @in_content
        content = data.gsub(/[ \t\n]+/, " ").strip
        @p << content unless content.empty?
      end
    end
  end
end
