require "csv"

require_relative "dataset"

module Datasets
  class Adult < Dataset
    Record = Struct.new(
      :age,
      :work_class,
      :final_weight,
      :education,
      :n_education_years,
      :marital_status,
      :occupation,
      :relationship,
      :race,
      :sex,
      :capital_gain,
      :capital_loss,
      :hours_per_week,
      :native_country,
      :label
    )

    def initialize(type: :train)
      unless [:train, :test].include?(type)
        raise ArgumentError, 'Please set type :train or :test'
      end

      super()
      @type = type
      @metadata.id = "adult-#{@type}"
      @metadata.name = "Adult: #{@type}"
      @metadata.url = "http://archive.ics.uci.edu/ml/datasets/adult"
      @metadata.description = lambda do
        read_names
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          next if row[0].nil?
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def open_data
      case @type
      when :train
        ext = "data"
      when :test
        ext = "test"
      end
      data_path = cache_dir_path + "adult-#{ext}.csv"
      unless data_path.exist?
        data_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.#{ext}"
        download(data_path, data_url)
      end

      options = {
                 converters: [:numeric, lambda {|f| f.strip}],
                 skip_lines: /\A\|/,
      }
      CSV.open(data_path, **options) do |csv|
        yield(csv)
      end
    end

    def read_names
      names_path = cache_dir_path + "adult.names"
      unless names_path.exist?
        names_url = "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.names"
        download(names_path, names_url)
      end
      names_path.read
    end
  end
end
