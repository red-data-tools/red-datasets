#!/usr/bin/ruby

require 'datasets'

wine = Datasets::Wine.new
wine.each do |record|
  p [
    record.class,
    record.alcohol,
    record.malic_acid,
    record.ash,
    record.alcalinity_of_ash,
    record.n_magnesiums,
    record.total_phenols,
    record.n_flavonoids,
    record.n_nonflavanoid_phenols,
    record.n_proanthocyanins,
    record.color_intensity,
    record.hue,
    record.optical_nucleic_acid_concentration,
    record.n_proline
  ]
end
