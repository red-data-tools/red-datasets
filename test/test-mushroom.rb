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
                    :label=>"p",
                    :cap_shape=>"x",
                    :cap_surface=>"s",
                    :cap_color=>"n",
                    :bruises=>"t",
                    :odor=>"p",
                    :gill_attachment=>"f",
                    :gill_spacing=>"c",
                    :gill_size=>"n",
                    :gill_color=>"k",
                    :stalk_shape=>"e",
                    :stalk_root=>"e",
                    :stalk_surface_above_ring=>"s",
                    :stalk_surface_below_ring=>"s",
                    :stalk_color_above_ring=>"w",
                    :stalk_color_below_ring=>"w",
                    :veil_type=>"p",
                    :veil_color=>"w",
                    :ring_number=>"o",
                    :ring_type=>"p",
                    :spore_print_color=>"k",
                    :population=>"s",
                    :habitat=>"u"
                   },
                   {
                    :label=>"e",
                    :cap_shape=>"x",
                    :cap_color=>"n",
                    :bruises=>"f",
                    :odor=>"n",
                    :gill_attachment=>"a",
                    :gill_spacing=>"c",
                    :gill_size=>"b",
                    :gill_color=>"y",
                    :stalk_shape=>"e",
                    :stalk_root=>"?",
                    :cap_surface=>"s",
                    :stalk_surface_above_ring=>"s",
                    :stalk_surface_below_ring=>"s",
                    :stalk_color_above_ring=>"o",
                    :stalk_color_below_ring=>"o",
                    :veil_type=>"p",
                    :veil_color=>"o",
                    :ring_number=>"o",
                    :ring_type=>"p",
                    :spore_print_color=>"o",
                    :population=>"c",
                    :habitat=>"l"
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
