defmodule UtilsTest do
  use ExUnit.Case

  for {direction, distance, expected} <- [
        {:north, 1, {-1, 0}},
        {:north, 4, {-4, 0}},
        {:northeast, 1, {-1, 1}},
        {:northwest, 1, {-1, -1}},
        {:south, 1, {1, 0}},
        {:southeast, 1, {1, 1}},
        {:southwest, 1, {1, -1}},
        {:southwest, 4, {4, -4}},
        {:east, 1, {0, 1}},
        {:west, 1, {0, -1}}
      ] do
    test "Check #{direction} direction generates correct results with magnitude #{distance}" do
      assert Utils.direction_operator(0, 0, unquote(direction), unquote(distance)) ==
               unquote(expected)
    end
  end

  for {row, column, expected} <- [
        {0, 0, true},
        {0, -1, false},
        {-1, -1, false},
        {-1, 0, false},
        {20, 20, false},
        {20, 19, false},
        {19, 20, false},
        {19, 19, true}
      ] do
    test "Checks check on map, coordinates #{row},#{column} expected #{expected}" do
      assert Day6.check_on_map(unquote(row), unquote(column), 20, 20) == unquote(expected)
    end
  end

  test "Check parse functions properly" do
    assert Utils.parse_string_to_two_tuple(".#.\n.^.") == {{".", "#", "."}, {".", "^", "."}}
  end

  test "Check get potential next steps" do
    assert Utils.get_pot_next_steps(0, 0, [:north, :south, :east, :west], 1) == [
             {-1, 0},
             {1, 0},
             {0, 1},
             {0, -1}
           ]
  end

  test "Check get value from 2d tuple" do
    assert Utils.get_value_from_2d_tuple({{".", "#", "."}, {".", "^", "."}}, 1, 1) == "^"
  end

  test "Print tuple" do
    assert Utils.print_tuple({1, 2, 3}) == "{1,2,3}"
  end

  test "check generate map" do
    assert Utils.generate_map_from_split_str(".A.\nBB.") == %{
             "A" => [{1,0}],
             "B" => [{0,1}, {1, 1}],
             "."=>[{0,0},{2,0},{2,1}]
           }

    assert Utils.generate_map_from_split_str("CAC\nBBD") == %{
             "A" => [{1,0}],
             "B" => [{0,1}, {1, 1}],
             "C" => [{0, 0}, {2,0}],
             "D" => [{2,1}]
           }
  end

  for {current_point, target, expected} <- [
        {{3, 0}, {0, 4}, 5.0}
      ] do
    test "Check distance #{Utils.print_tuple(current_point)}, #{Utils.print_tuple(target)}" do
      assert Utils.distance(unquote(current_point), unquote(target)) == unquote(expected)
    end
  end

  for {current_point, target, expected} <- [
        {{3, 0}, {0, 4}, 7},
        {{0, 0}, {1, 1}, 2}
      ] do
    test "Check manhattan #{Utils.print_tuple(current_point)}, #{Utils.print_tuple(target)}" do
      assert Utils.manhattan(unquote(current_point), unquote(target)) == unquote(expected)
    end
  end

  for {str_desc, points, lists, expected} <- [
        {"2 points not filtered", [{{3, 0}, :north}, {{0, 4}, :north}], [],
         [{{3, 0}, :north}, {{0, 4}, :north}]},
        {"2 points filtered by 1 list", [{{3, 0}, :north}, {{0, 4}, :north}], [[{3, 0}, {0, 4}]],
         []},
        {"2 points filtered by 2 lists", [{{3, 0}, :north}, {{0, 4}, :north}],
         [[{3, 0}, {5, 0}], [{0, 4}]], []},
        {"2 points filtered by 2 lists, 1 survivor", [{{3, 0}, :north}, {{0, 4}, :north}],
         [[{3, 0}, {5, 0}], [{6, 0}]], [{{0, 4}, :north}]}
      ] do
    test "Check filter_elements_from_multiple_lists #{str_desc}" do
      assert Utils.filter_elements_from_multiple_lists(unquote(points), unquote(lists)) ==
               unquote(expected)
    end
  end
end
