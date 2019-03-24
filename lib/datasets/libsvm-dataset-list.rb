require "English"
require "rexml/document"

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
      @metadata.description = lambda do
        extract_description
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |input|
        # TODO: Improve performance
        document = REXML::Document.new(input)
        is_header = true
        document.each_element("//tr") do |tr|
          if is_header
            is_header = false
            next
          end
          name = tr.elements.first
          a = name.elements.first
          href = a.attributes["href"]
          record = Record.new
          record.name = a.text
          record.files = []
          parse_detail(href, record)
          yield(record)
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "index.html"
      unless data_path.exist?
        download(data_path, @metadata.url)
      end
      ::File.open(data_path) do |input|
        yield(input)
      end
    end

    def extract_description
      open_data do |input|
        document = REXML::Document.new(input)
        description = []
        in_content = false
        document.each_element("//body/*") do |element|
          unless in_content
            in_content = (element.name == "h1")
            next
          end
          break if element.name == "hr"
          content = extract_text(element)
          description << content unless content.empty?
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
      unless data_path.exist?
        download(data_path, @metadata.url + detail)
      end
      ::File.open(data_path) do |input|
        yield(input)
      end
    end

    def parse_detail(href, record)
      path, id = href.split("#")
      open_detail(path) do |detail|
        detail_document = REXML::Document.new(detail)
        anchor = REXML::XPath.match(detail_document, "//*[@name='#{id}']")[0]
        ul = anchor.next_sibling
        ul.each_element do |li|
          text = extract_text(li)
          case text
          when /\ASource: /
            record.source = $POSTMATCH
          when /\APreprocessing: /
            record.preprocessing = $POSTMATCH
          when /\A\# of classes: (\d+)/
            record.n_classes = Integer($1, 10)
          when /\A\# of data: ([\d,]+)/
            record.n_data = Integer($1.gsub(/,/, ""), 10)
          when /\A\# of features: ([\d,]+)/
            record.n_features = Integer($1.gsub(/,/, ""), 10)
          when /\AFiles:/
            li.elements.first.each_element do |file_li|
              file_a = file_li.elements.first
              file = File.new
              file.name = file_a.text
              file.url = @metadata.url + file_a.attributes["href"]
              file_note = file_li.text
              file.note = file_note.strip.gsub(/[()]/, "") if file_note
              record.files << file
            end
          end
        end
      end
    end
  end
end
