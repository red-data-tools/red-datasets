require "csv"
require_relative 'zip-extractor'

module Datasets
  class AFINN < Dataset
    Record = Struct.new(:word,
                        :valence)

    def initialize
      super()
      @metadata.id = "afinn"
      @metadata.name = "AFINN"
      @metadata.url = "http://www2.imm.dtu.dk/pubdb/pubs/6010-full.html"
      @metadata.licenses = ["ODbL-1.0"]
      @metadata.description = <<-DESCRIPTION
        AFINN is a list of English words rated for valence with an integer
between minus five (negative) and plus five (positive). The words have
been manually labeled by Finn Årup Nielsen in 2009-2011. The file
is tab-separated. There are two versions:

AFINN-111: Newest version with 2477 words and phrases, which is used here.

AFINN-96: 1468 unique words and phrases on 1480 lines. Note that there
are 1480 lines, as some words are listed twice. The word list in not
entirely in alphabetic ordering.  

An evaluation of the word list is available in:

Finn Årup Nielsen, "A new ANEW: Evaluation of a word list for
sentiment analysis in microblogs", http://arxiv.org/abs/1103.2903

The list was used in: 

Lars Kai Hansen, Adam Arvidsson, Finn Årup Nielsen, Elanor Colleoni,
Michael Etter, "Good Friends, Bad News - Affect and Virality in
Twitter", The 2011 International Workshop on Social Computing,
Network, and Services (SocialComNet 2011).


This database of words is copyright protected and distributed under
"Open Database License (ODbL) v1.0"
http://www.opendatacommons.org/licenses/odbl/1.0/ or a similar
copyleft license.

See comments on the word list here:
http://fnielsen.posterous.com/old-anew-a-sentiment-about-sentiment-analysis
      DESCRIPTION
    end

    def each
      return to_enum(__method__) unless block_given?

      file_path = "AFINN/AFINN-111.txt"
      data_path = cache_dir_path + "imm6010.zip"
      data_url = "http://www2.imm.dtu.dk/pubdb/edoc/imm6010.zip"
      download(data_path, data_url)

      extractor = ZipExtractor.new(data_path)
      extractor.extract_named_file(file_path) do |input|
        csv = CSV.new(input, col_sep: "\t", converters: :numeric)
        csv.each do |row|
          yield(Record.new(*row))
        end
      end
    end
  end
end
