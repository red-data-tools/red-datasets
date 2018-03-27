module Datasets
  class Table
    def initialize(dataset)
      @dataset = dataset
    end

    def to_h
      columns = {}
      @dataset.each do |record|
        record.to_h.each do |name, value|
          values = (columns[name] ||= [])
          values << value
        end
      end
      columns
    end
  end
end
