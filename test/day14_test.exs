defmodule Day14Test do
  use ExUnit.Case

  for {starting_position, slope, turns, size_x, size_y, expected} <- [
        {{1, 1}, {1, 1}, 1, 10, 10, {2, 2}},
        {{1, 1}, {1, 1}, 2, 10, 10, {3, 3}},
        {{1, 1}, {1, 1}, 10, 10, 10, {1, 1}},
        {{1, 1}, {1, 1}, 100, 10, 10, {1, 1}},
        {{1, 1}, {-4, 1}, 1, 10, 10, {7, 2}}
      ] do
    test "Check find_spot_after_n_turns #{Utils.print_tuple(starting_position)}, slope #{Utils.print_tuple(slope)}, for turns #{turns}" do
      assert Day14.find_spot_after_n_turns(
               unquote(starting_position),
               unquote(slope),
               unquote(turns),
               unquote(size_x),
               unquote(size_y)
             ) == unquote(expected)
    end
  end

  for {input, expected} <- [
        {"p=0,4 v=3,-3", {{0, 4}, {3, -3}}},
        {"p=6,3 v=-1,-3", {{6, 3}, {-1, -3}}},
        {"p=10,3 v=-1,2", {{10, 3}, {-1, 2}}},
        {"p=2,0 v=2,-1", {{2, 0}, {2, -1}}},
        {"p=0,0 v=1,3", {{0, 0}, {1, 3}}},
        {"p=3,0 v=-2,-2", {3, 0}, {-2, -2}},
        {"p=7,6 v=-1,-3", {{7, 6}, {-1, -3}}},
        {"p=3,0 v=-1,-2", {{3, 0}, {-1, -2}}},
        {"p=9,3 v=2,3", {{9, 3}, {2, 3}}},
        {"p=7,3 v=-1,2", {{7, 3}, {-1, 2}}},
        {"p=2,4 v=2,-3", {{2, 4}, {2, -3}}},
        {"p=9,5 v=-3,-3", {{9, 5}, {-3, -3}}}
      ] do
    test "Check parse_position_and_slope #{input}" do
      assert Day14.parse_position_and_slope(unquote(input)) == unquote(expected)
    end
  end

  for {point, size_x, size_y, expected} <- [
        {{1, 1}, 11, 11, :first},
        {{1, 9}, 11, 11, :second},
        {{9, 9}, 11, 11, :third},
        {{9, 1}, 11, 11, :fourth},
        {{5, 5}, 11, 11, :remove}
      ] do
    test "Check get_point_quadrant #{Utils.print_tuple(point)} sizes x #{size_x}, x #{size_y}" do
      assert Day14.get_point_quadrant(unquote(point), unquote(size_x), unquote(size_y)) ==
               unquote(expected)
    end
  end

  test "Check run small example on count_quadrants" do
    input =
      "p=0,4 v=3,-3\np=6,3 v=-1,-3\np=10,3 v=-1,2\np=2,0 v=2,-1\np=0,0 v=1,3\np=3,0 v=-2,-2\np=7,6 v=-1,-3\np=3,0 v=-1,-2\np=9,3 v=2,3\np=7,3 v=-1,2\np=2,4 v=2,-3\np=9,5 v=-3,-3"

    assert Day14.count_quadrants(input, 100, 11, 7) == %{
             :first => 1,
             :second => 4,
             :third => 1,
             :remove => 3,
             :fourth => 3
           }

    assert Day14.mult_quadrants(Day14.count_quadrants(input, 100, 11, 7)) == 12
  end
end
