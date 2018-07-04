#!/usr/bin/env ruby -I./lib

require "datasets"
require "optparse"

params = ARGV.getopts("n:")

ptb = Datasets::PennTreebank.new(type: :train, keep_vocabulary: true)

if params["n"]
  ptb.each.take(params["n"].to_i).each {|index| puts ptb.vocabulary.keys[index] }
else
  ptb.each {|index| puts ptb.vocabulary.keys[index] }
end
