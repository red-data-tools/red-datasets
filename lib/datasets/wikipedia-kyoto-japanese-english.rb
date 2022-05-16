require "csv"
require "rexml/streamlistener"
require "rexml/parsers/baseparser"
require "rexml/parsers/streamparser"
require "time"

require_relative "dataset"
require_relative "tar-gz-readable"

module Datasets
  class WikipediaKyotoJapaneseEnglish < Dataset
    include TarGzReadable

    Article = Struct.new(:source,
                         :copyright,
                         :contents,
                         :sections)

    Section = Struct.new(:id,
                         :title,
                         :contents)

    class Title < Struct.new(:section,
                             :japanese,
                             :english)
      def title?
        true
      end

      def sentence?
        false
      end
    end

    Paragraph = Struct.new(:id,
                           :sentences)

    class Sentence < Struct.new(:id,
                                :section,
                                :paragraph,
                                :japanese,
                                :english)
      def title?
        false
      end

      def sentence?
        true
      end
    end

    Entry = Struct.new(:japanese,
                       :english)

    def initialize(type: :article)
      unless [:article, :lexicon].include?(type)
        raise ArgumentError, "Please set type :article or :lexicon: #{type.inspect}"
      end

      super()
      @type = type
      @metadata.id = "wikipedia-kyoto-japanese-english"
      @metadata.name =
        "The Japanese-English Bilingual Corpus of Wikipedia's Kyoto Articles"
      @metadata.url = "https://alaginrc.nict.go.jp/WikiCorpus/index_E.html"
      @metadata.licenses = ["CC-BY-SA-3.0"]
      @metadata.description = <<-DESCRIPTION
"The Japanese-English Bilingual Corpus of Wikipedia's Kyoto Articles"
aims mainly at supporting research and development relevant to
high-performance multilingual machine translation, information
extraction, and other language processing technologies. The National
Institute of Information and Communications Technology (NICT) has
created this corpus by manually translating Japanese Wikipedia
articles (related to Kyoto) into English.
      DESCRIPTION
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = download_tar_gz

      open_tar_gz(data_path) do |tar|
        tar.each do |entry|
          next unless entry.file?
          base_name = File.basename(entry.full_name)
          case @type
          when :article
            next unless base_name.end_with?(".xml")
            listener = ArticleListener.new(block)
            parser = REXML::Parsers::StreamParser.new(entry.read, listener)
            parser.parse
          when :lexicon
            next unless base_name == "kyoto_lexicon.csv"
            is_header = true
            CSV.parse(entry.read.force_encoding("UTF-8")) do |row|
              if is_header
                is_header = false
                next
              end
              yield(Entry.new(row[0], row[1]))
            end
          end
        end
      end
    end

    private
    def download_tar_gz
      base_name = "wiki_corpus_2.01.tar.gz"
      data_path = cache_dir_path + base_name
      data_url = "https://alaginrc.nict.go.jp/WikiCorpus/src/#{base_name}"
      download(data_path, data_url)
      data_path
    end

    class ArticleListener
      include REXML::StreamListener

      def initialize(block)
        @block = block
        @article = nil
        @title = nil
        @section = nil
        @page = nil
        @sentence = nil
        @text_container_stack = []
        @element_stack = []
        @text_stack = [""]
      end

      def tag_start(name, attributes)
        push_stacks(name, attributes)
        case name
        when "art"
          @article = Article.new
          @article.contents = []
          @article.sections = []
        when "tit"
          @title = Title.new
          @title.section = @section
          @text_container_stack.push(@title)
        when "sec"
          @section = Section.new
          @section.id = attributes["id"]
          @section.contents = []
          @text_container_stack.push(@section)
        when "par"
          @paragraph = Paragraph.new
          @paragraph.id = attributes["id"]
          @paragraph.sentences = []
          @text_container_stack.push(@paragraph)
        when "sen"
          @sentence = Sentence.new
          @sentence.id = attributes["id"]
          @text_container_stack.push(@sentence)
        end
      end

      def tag_end(name)
        case name
        when "art"
          @block.call(@article)
          @article = nil
        when "inf"
          @article.source = @text_stack.last
        when "copyright"
          @article.copyright = @text_stack.last
        when "tit"
          @article.contents << @title
          if @section
            @section.title = @title
            @section.contents << @title
          end
          @title = nil
          @text_container_stack.pop
        when "sec"
          @article.sections << @section
          @section = nil
          @text_container_stack.pop
        when "par"
          @paragraph = nil
          @text_container_stack.pop
        when "sen"
          @article.contents << @sentence
          @sentence.section = @section
          @section.contents << @sentence if @section
          @sentence.paragraph = @paragraph
          @paragraph.sentences << @sentence if @paragraph
          @sentence = nil
          @text_container_stack.pop
        when "j"
          @text_container_stack.last.japanese = @text_stack.last
        when "e"
          attributes = @element_stack.last[:attributes]
          if attributes["type"] == "check"
            @text_container_stack.last.english = @text_stack.last
          end
        end
        pop_stacks
      end

      def text(data)
        @text_stack.last << data
      end

      private
      def push_stacks(name, attributes)
        @element_stack.push({name: name, attributes: attributes})
        @text_stack.push("")
      end

      def pop_stacks
        @text_stack.pop
        @element_stack.pop
      end
    end
  end
end
