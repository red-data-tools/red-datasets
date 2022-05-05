require "rexml/streamlistener"
require "rexml/parsers/baseparser"
require "rexml/parsers/streamparser"
require "time"

require_relative "dataset"
require_relative "tar-gz-readable"

module Datasets
  class JapaneseEnglishBilingualCorpus < Dataset
    include TarGzReadable
    Article = Struct.new(:id,
                         :copyright)

    Title = Struct.new(:article_id,
                      :japanese,
                      :translate_ver1,
                      :translate_ver1_comment,
                      :translate_ver2,
                      :translate_ver2_comment,
                      :check_ver1,
                      :check_ver1_comment)

    Section = Struct.new(:article_id,
                      :id,
                      :japanese,
                      :translate_ver1,
                      :translate_ver1_comment,
                      :translate_ver2,
                      :translate_ver2_comment,
                      :check_ver1,
                      :check_ver1_comment)
    
    Page = Struct.new(:article_id,
                      :section_id,
                      :id)

    Sentence = Struct.new(:article_id,
                      :section_id,
                      :page_id,
                      :id,
                      :japanese,
                      :translate_ver1,
                      :translate_ver1_comment,
                      :translate_ver2,
                      :translate_ver2_comment,
                      :check_ver1,
                      :check_ver1_comment) 

    def initialize(type: :BDS)
      category_list = [
        :BDS,
        :BLD,
        :CLT,
        :EPR,
        :FML,
        :GNM,
        :HST,
        :LTT,
        :PNM,
        :RLW,
        :ROD,
        :SAT,
        :SCL,
        :SNT,
        :TTL
      ]
      unless category_list.include?(type)
        valid_type_labels = category_list.collect(&:inspect).join(", ")
        message = ":type must be one of [#{valid_type_labels}]: #{type.inspect}"
        raise ArgumentError, message
      end

      super()
      @type = type
      @metadata.id = "japanese-english-bilingual-corpus"
      @metadata.name = "Japanse-English-Bilingual-Corpus"
      @metadata.url = "https://alaginrc.nict.go.jp/WikiCorpus/index_E.html"
      @metadata.licenses = ["CC-BY-SA-3.0"]
      #TODO
      @metadata.description = ""
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = download_tar_gz

      target_directory_name = "#{@type.to_s}"
      open_tar_gz(data_path) do |tar|
        tar.each do |entry|
          next unless entry.file?
          directory_name, base_name = File.split(entry.full_name)
          next unless directory_name == target_directory_name
          listener = ArticlesListener.new(block)
          parser = REXML::Parsers::StreamParser.new(entry.read, listener)
          parser.parse
        end
      end
    end

    private
    def download_tar_gz
      data_path = cache_dir_path + "wiki_corpus_2.01.tar.gz"
      data_url = "https://alaginrc.nict.go.jp/WikiCorpus/src/wiki_corpus_2.01.tar.gz"
      download(data_path, data_url)
      data_path
    end

    class ArticlesListener
      include REXML::StreamListener

      def initialize(block)
        @block = block
        @article = nil
        @title = nil
        @section = nil
        @page = nil
        @sentence = nil
        @tag_stack = []
        @text_stack = [""]
      end

      def tag_start(name, attributes)
        push_stacks(name)
        case name
        when "inf"
          @article = Article.new
        when "tit"
          if @tag_stack[-2] != "sec"
            @title = Title.new
          end
        when "sec"
          @section = Section.new
          @section.id = attributes["id"]  
        when "par"
          @page = Page.new
          @page.id = attributes["id"]
        when "sen"
          @sentence = Sentence.new
          @sentence.id = attributes["id"]
        end
      end

      def tag_end(name)
        case name
        when "art"
          on_target(@article)
          @article = nil
        when "inf"
          @article.id = @text_stack.last
        when "copyright"
          @article.copyright = @text_stack.last
        when "tit"
          if @tag_stack[-2] == 'art'
            @title.article_id = @article.id
            on_target(@title)
            @title = nil
          end
        when "sec"
          @section.article_id = @article.id
          on_target(@section)
          @section = nil
        when "par"
          @page.article_id = @article.id
          if @section != nil
            @page.section_id = @section.id
          end
          on_target(@page)
          @page = nil
        when "sen"
          @sentence.article_id = @article.id
          if @section != nil
            @sentence.section_id = @section.id
          end
          on_target(@sentence)
          @sentence = nil
        when "j"
          case @tag_stack[-2]
          when "tit"
            if @tag_stack[-3] == 'art'
              @title.japanese = @text_stack.last
            elsif @tag_stack[-3] == 'sec'
              @section.japanese = @text_stack.last
            end
          when "sen"
            @sentence.japanese = @text_stack.last
          end
        when "e"
          case @tag_stack[-2]
          when "tit"
            if @tag_stack[-3] == 'art'
              if @title.translate_ver1 == nil
                @title.translate_ver1 = @text_stack.last
              elsif @title.translate_ver1 != nil && @title.translate_ver2 == nil
                @title.translate_ver2 = @text_stack.last
              elsif @title.translate_ver2 != nil && @title.check_ver1 == nil
                @title.check_ver1 = @text_stack.last
              end
            elsif @tag_stack[-3] == 'sec'
              if @section.translate_ver1 == nil
                @section.translate_ver1 = @text_stack.last
              elsif @section.translate_ver1 != nil && @section.translate_ver2 == nil
                @section.translate_ver2 = @text_stack.last
              elsif @section.translate_ver2 != nil && @section.check_ver1 == nil
                @section.check_ver1 = @text_stack.last
              end
            end
          when "sen"
            if @sentence.translate_ver1 == nil
              @sentence.translate_ver1 = @text_stack.last
            elsif @sentence.translate_ver1 != nil && @sentence.translate_ver2 == nil
              @sentence.translate_ver2 = @text_stack.last
            elsif @sentence.translate_ver2 != nil && @sentence.check_ver1 == nil
              @sentence.check_ver1 = @text_stack.last
            end
          end
        when "cmt"
          case @tag_stack[-2]
          when "tit"
            if @tag_stack[-3] == 'art'
              if @title.translate_ver1_comment == nil
                @title.translate_ver1_comment = @text_stack.last
              elsif @title.translate_ver1_comment != nil && @title.translate_ver2_comment == nil
                @title.translate_ver2_comment = @text_stack.last
              elsif @title.translate_ver2_comment != nil && @title.check_ver1_comment == nil
                @title.check_ver1_comment = @text_stack.last
              end
            elsif @tag_stack[-3] == 'sec'
              if @section.translate_ver1_comment == nil
                @section.translate_ver1_comment = @text_stack.last
              elsif @section.translate_ver1_comment != nil && @section.translate_ver2_comment == nil
                @section.translate_ver2_comment = @text_stack.last
              elsif @section.translate_ver2_comment != nil && @section.check_ver1_comment == nil
                @section.check_ver1_comment = @text_stack.last
              end
            end
          when "sen"
            if @sentence.translate_ver1_comment == nil
              @sentence.translate_ver1_comment = @text_stack.last
            elsif @sentence.translate_ver1_comment != nil && @sentence.translate_ver2_comment == nil
              @sentence.translate_ver2_comment = @text_stack.last
            elsif @sentence.translate_ver2_comment != nil && @sentence.check_ver1_comment == nil
              @sentence.check_ver1_comment = @text_stack.last
            end
          end
        end
        pop_stacks
      end

      def text(data)
        @text_stack.last << data
      end

      private
      def on_target(target)
        @block.call(target)
      end

      def push_stacks(tag)
        @tag_stack << tag
        @text_stack << ""
      end

      def pop_stacks
        @text_stack.pop
        @tag_stack.pop
      end
    end
  end
end