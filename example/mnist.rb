#!/usr/bin/env ruby

require "datasets"

mnist = Datasets::MNIST.new(type: :train)
mnist.each do |record|
  p record.pixels
  # => [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, .....]
  p record.label
  # => 5
end
