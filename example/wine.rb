#!/usr/bin/ruby

require 'datasets'

wine = Datasets::Wine.new
wine.each do |record|
  p [
    record.wine_class,
    record.alcohol,
    record.malic_acid,
    record.ash,
    record.alcalinity_of_ash,
    record.magnesium,
    record.total_phenols,
    record.flavanoids,
    record.nonflavanoid_phenols,
    record.proanthocyanins,
    record.color_intensity,
    record.hue,
    record.od280_od315_of_diluted_wines,
    record.proline
  ]
end
