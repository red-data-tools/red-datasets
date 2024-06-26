require "rexml/streamlistener"
require "rexml/parsers/baseparser"
require "rexml/parsers/streamparser"
require "time"

require_relative "dataset"

module Datasets
  class Wikipedia < Dataset
    Contributor = Struct.new(:user_name,
                             :id)
    Revision = Struct.new(:id,
                          :parent_id,
                          :timestamp,
                          :contributor,
                          :minor,
                          :comment,
                          :model,
                          :format,
                          :text,
                          :sha1)
    Page = Struct.new(:title,
                      :namespace,
                      :id,
                      :restrictions,
                      :redirect,
                      :revision)

    def initialize(language: :en,
                   type: :articles)
      super()
      @language = language
      @type = type
      @metadata.id = "wikipedia-#{@language}-#{@type}"
      @metadata.name = "Wikipedia #{@type} (#{@language})"
      @metadata.url = "https://dumps.wikimedia.org/"
      @metadata.licenses = [
        "CC-BY-SA-3.0",
        "CC-BY-SA-4.0",
        "GFDL-1.3-or-later",
      ]
      @metadata.description = "Wikipedia #{@type} in #{@language}"
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      open_data do |input|
        listener = ArticlesListener.new(block)
        parser = REXML::Parsers::StreamParser.new(input, listener)
        parser.parse
      end
    end

    private
    def base_name
      "#{@language}wiki-latest-#{type_in_path}.xml.bz2"
    end

    def data_path
      cache_dir_path + base_name
    end

    def open_data(&block)
      data_url = "https://dumps.wikimedia.org/#{@language}wiki/latest/#{base_name}"
      bz2 = Enumerator.new do |yielder|
        download(data_path, data_url) do |bz2_chunk|
          yielder << bz2_chunk
        end
      end
      extract_bz2(bz2, &block)
    end

    def type_in_path
      case @type
      when :articles
        "pages-articles"
      else
        @type.to_s
      end
    end

    class ArticlesListener
      include REXML::StreamListener

      def initialize(block)
        @block = block
        @page = nil
        @revision = nil
        @contributor = nil
        @current_tag = nil
        @tag_stack = []
        @text_stack = [+""]
        @first_page = true
      end

      def tag_start(name, attributes)
        push_stacks(name)
        case name
        when "page"
          @page = Page.new
        when "revision"
          @revision = Revision.new
        when "contributor"
          @contributor = Contributor.new
        when "redirect"
          @page.redirect = attributes["title"]
        end
      end

      def tag_end(name)
        case name
        when "page"
          on_page(@page)
          @page = nil
        when "title"
          @page.title = @text_stack.last
        when "ns"
          @page.namespace = Integer(@text_stack.last)
        when "id"
          id = Integer(@text_stack.last)
          case @tag_stack[-2]
          when "page"
            @page.id = id
          when "revision"
            @revision.id = id
          when "contributor"
            @contributor.id = id
          end
        when "restrictions"
          @page.restrictions = @text_stack.last.split(":")
        when "revision"
          @page.revision = @revision
          @revision = nil
        when "parentid"
          @revision.parent_id = Integer(@text_stack.last)
        when "timestamp"
          @revision.timestamp = Time.iso8601(@text_stack.last)
        when "contributor"
          @revision.contributor = @contributor
          @contributor = nil
        when "username"
          @contributor.user_name = @text_stack.last
        when "minor"
          # TODO
        when "comment"
          @revision.comment = @text_stack.last
        when "model"
          @revision.model = @text_stack.last
        when "format"
          @revision.format = @text_stack.last
        when "text"
          @revision.text = @text_stack.last
        when "sha1"
          @revision.sha1 = @text_stack.last
        end
        pop_stacks
      end

      def text(data)
        @text_stack.last << data
      end

      def cdata(content)
        @text_stack.last << content
      end

      private
      def on_page(page)
        @block.call(page)
      end

      def push_stacks(tag)
        @tag_stack << tag
        @text_stack << +""
      end

      def pop_stacks
        @text_stack.pop
        @tag_stack.pop
      end
    end
  end
end
