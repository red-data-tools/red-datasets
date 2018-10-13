class PennTreebankTest < Test::Unit::TestCase
  def record(*args)
    Datasets::PennTreebank::Record.new(*args)
  end

  sub_test_case("type") do
    test("train") do
      dataset = Datasets::PennTreebank.new(type: :train)
      records = dataset.to_a
      assert_equal([
                     887521,
                     record("aer"),
                     record("<unk>"),
                   ],
                   [
                     records.size,
                     records[0],
                     records[-1],
                   ])
    end

    test("test") do
      dataset = Datasets::PennTreebank.new(type: :test)
      records = dataset.to_a
      assert_equal([
                     78669,
                     record("no"),
                     record("us"),
                   ],
                   [
                     records.size,
                     records[0],
                     records[-1],
                   ])
    end

    test("valid") do
      dataset = Datasets::PennTreebank.new(type: :valid)
      records = dataset.to_a
      assert_equal([
                     70390,
                     record("consumers"),
                     record("N"),
                   ],
                   [
                     records.size,
                     records[0],
                     records[-1],
                   ])
    end

    test("invalid") do
      message = "Type must be one of [:train, :test, :valid]: :invalid"
      assert_raise(ArgumentError.new(message)) do
        Datasets::PennTreebank.new(type: :invalid)
      end
    end
  end
end
