#!/usr/bin/env ruby

require "datasets"

iris = Datasets::Iris.new
iris.each do |record|
  p [
     record.sepal_length,
     record.sepal_width,
     record.petal_length,
     record.petal_width,
     record.label,
  ]
  # [5.1, 3.5, 1.4, 0.2, "Iris-setosa"]
  # [7.0, 3.2, 4.7, 1.4, "Iris-versicolor"]
end
