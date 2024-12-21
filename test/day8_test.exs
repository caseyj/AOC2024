defmodule Day8Test do
  use ExUnit.Case

  for {input1, input2, expected} <- [
        {{0, 0}, {0, 0}, {0, 0}},
        {{1, 0}, {0, 0}, {1, 0}},
        {{0, 0}, {0, 1}, {0, 1}},
        {{1, 2}, {3, 4}, {4, 6}},
        {{1, 2}, {-3, -4}, {-2, -2}}
      ] do
    test "Check tuple sums are correct #{elem(expected, 0)},#{elem(expected, 1)} " do
      assert Day8.tuple_sum(unquote(input1), unquote(input2)) == unquote(expected)
    end
  end

  for {input1, expected} <- [
        {{0, 0}, {0, 0}},
        {{1, 0}, {-1, 0}},
        {{0, 1}, {0, -1}},
        {{1, 2}, {-1, -2}},
        {{1, -2}, {-1, 2}}
      ] do
    test "Check tuple negation #{elem(input1, 0)},#{elem(input1, 1)} are correct #{elem(expected, 0)},#{elem(expected, 1)} " do
      assert Day8.negate_tuple(unquote(input1)) == unquote(expected)
    end
  end

  for {left, right, expected} <- [
        {{0, 0}, {0, 0}, {0, 0}},
        {{0, 1}, {0, 0}, {0, -1}},
        {{2, 0}, {2, 1}, {0, 1}},
        {{1, 1}, {2, 2}, {1, 1}},
        {{2, 2}, {1, 1}, {-1, -1}},
        {{1, 2}, {5, 10}, {4, 8}},
        {{5, 10}, {1, 2}, {-4, -8}}
      ] do
    test "Check get slope {#{elem(left, 0)},#{elem(left, 1)}} {#{elem(right, 0)},#{elem(right, 1)}} are correct #{elem(expected, 0)},#{elem(expected, 1)}" do
      assert Day8.get_slope(unquote(left), unquote(right)) == unquote(expected)
    end
  end

  for {left, right, direction, expected} <- [
        {{0, 0}, {0, 0}, :next, {0, 0}},
        {{0, 0}, {0, 1}, :next, {0, 1}},
        {{2, 0}, {2, 1}, :next, {4, 1}},
        {{1, 1}, {2, 2}, :previous, {-1, -1}},
        {{2, 2}, {1, 1}, :previous, {1, 1}},
        {{1, 2}, {5, 10}, :previous, {-4, -8}}
      ] do
    test "Check get next point {#{elem(left, 0)},#{elem(left, 1)}} {#{elem(right, 0)},#{elem(right, 1)}} #{direction} are correct " do
      assert Day8.get_next_point(unquote(left), unquote(right), unquote(direction)) ==
               unquote(expected)
    end
  end

  for {left, right, direction, expected} <- [
        {{5, 5}, {1, 1}, :next, [{5, 5}, {6, 6}, {7, 7}, {8, 8}, {9, 9}]},
        {{5, 5}, {1, 1}, :previous, [{5, 5}, {4, 4}, {3, 3}, {2, 2}, {1, 1}, {0, 0}]}
      ] do
    test "Check get points in direction {#{elem(left, 0)},#{elem(left, 1)}} {#{elem(right, 0)},#{elem(right, 1)}} #{direction}" do
      assert Day8.get_points_in_direction_on_board(
               unquote(left),
               unquote(right),
               unquote(direction),
               10,
               10
             ) == unquote(expected)
    end
  end

  test "Check get points in both directions" do
    assert Day8.get_points_both_directions({4, 4}, {5, 5}, 10, 10) == [
             {6, 6},
             {7, 7},
             {8, 8},
             {9, 9},
             {3, 3},
             {2, 2},
             {1, 1},
             {0, 0}
           ]
  end

  test "check generate map" do
    assert Day8.generate_map_from_split_str(".A.\nBB.") == %{
             "A" => [{0, 1}],
             "B" => [{1, 0}, {1, 1}]
           }
  end

  test "Check self mix" do
    assert Day8.self_mix_pairings([{1, 2}, {3, 4}, {5, 6}]) == [
             [{1, 2}, {3, 4}],
             [{1, 2}, {5, 6}],
             [{3, 4}, {5, 6}]
           ]
  end

  test "Check part1" do
    assert Day8.part1("data/day8_sample.txt") == 15
  end

  test "check part 2 works" do
    antenae = [
      {0, 0},
      {0, 1},
      {0, 6},
      {0, 11},
      {1, 1},
      {1, 3},
      {2, 2},
      {2, 4},
      {2, 10},
      {3, 2},
      {3, 3},
      {4, 9},
      {5, 1},
      {5, 5},
      {5, 11},
      {6, 3},
      {6, 6},
      {7, 0},
      {7, 5},
      {7, 7},
      {8, 2},
      {9, 4},
      {10, 1},
      {10, 10},
      {11, 3},
      {11, 10},
      {11, 11}
    ]

    data_vals = Day8.get_points_from_str("data/day8_sample.txt")
    filtered = Enum.filter(data_vals, fn val -> Enum.member?(antenae, val) == false end)

    assert Enum.all?(Day8.get_points_from_str("data/day8_sample.txt"), fn ea ->
             Enum.member?(antenae, ea)
           end) == true
  end
end
