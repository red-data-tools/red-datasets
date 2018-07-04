#!/usr/bin/env ruby -I./lib

require "datasets"
require "optparse"

params = ARGV.getopts("n:")

ptb = Datasets::PennTreebank.new(type: :train)

if params["n"]
  records = ptb.take(params["n"].to_i)
else
  records = ptb
end

records.each {|record| puts record.word }
