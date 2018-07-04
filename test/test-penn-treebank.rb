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
                     record("aer", 1),
                     record("<unk>", 9999),
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
                     record("no", 1),
                     record("us", 6048),
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
                     record("consumers", 1),
                     record("N", 6021),
                   ],
                   [
                     records.size,
                     records[0],
                     records[-1],
                   ])
    end
  end
end
