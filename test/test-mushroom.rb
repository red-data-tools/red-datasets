class MushroomTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Mushroom.new
  end

  def record(*args)
    Datasets::Mushroom::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   8124,
                   {
                     :label => "poisonous",
                     :cap_shape => "convex",
                     :cap_surface => "smooth",
                     :cap_color => "brown",
                     :bruises => "bruises",
                     :odor => "pungent",
                     :gill_attachment => "free",
                     :gill_spacing => "close",
                     :gill_size => "narrow",
                     :gill_color => "black",
                     :stalk_shape => "enlarging",
                     :stalk_root => "equal",
                     :stalk_surface_above_ring => "smooth",
                     :stalk_surface_below_ring => "smooth",
                     :stalk_color_above_ring => "white",
                     :stalk_color_below_ring => "white",
                     :veil_type => "partial",
                     :veil_color => "white",
                     :n_rings => 1,
                     :ring_type => "pendant",
                     :spore_print_color => "black",
                     :population => "scattered",
                     :habitat => "urban"
                   },
                   {
                     :label => "edible",
                     :cap_shape => "convex",
                     :cap_surface => "smooth",
                     :cap_color => "brown",
                     :bruises => "no",
                     :odor => "none",
                     :gill_attachment => "attached",
                     :gill_spacing => "close",
                     :gill_size => "broad",
                     :gill_color => "yellow",
                     :stalk_shape => "enlarging",
                     :stalk_root => "missing",
                     :stalk_surface_above_ring => "smooth",
                     :stalk_surface_below_ring => "smooth",
                     :stalk_color_above_ring => "orange",
                     :stalk_color_below_ring => "orange",
                     :veil_type => "partial",
                     :veil_color => "orange",
                     :n_rings => 1,
                     :ring_type => "pendant",
                     :spore_print_color => "orange",
                     :population => "clustered",
                     :habitat => "leaves"
                   }
                 ],
                 [
                   records.size,
                   records[0].to_h,
                   records[-1].to_h
                 ])
  end

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert do
        description.start_with?("1. Title: Mushroom Database")
      end
    end
  end
end
