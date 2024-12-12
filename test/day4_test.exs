defmodule Day4Test do
  use ExUnit.Case

  test "Check ingestion for 2 line string to become a tuple." do
    assert Day4.parse_input("abc\nefg") == [["a", "b", "c"], ["e", "f", "g"]]
  end

  test "Adding element to end of list inside a map" do
    assert Day4.add_r_c_to_map(%{"X" => []}, "X", {0, 1}, {0, 0}) == %{"X" => [{1, 0}]}
  end

  test "Adding multiple elements to single Map accumulator" do
    assert Day4.column_runner(%{"X" => [], "M" => [], "A" => [], "S" => []}, {["X", "M"], 0}) ==
             %{"X" => [{0, 0}], "M" => [{0, 1}], "A" => [], "S" => []}
  end

  test "Checking ingestion into map data structure" do
    assert Day4.input_to_map(Day4.parse_input("XMASXMAS\nXMASXMAS")) == %{
             "X" => [{0, 0}, {0, 4}, {1, 0}, {1, 4}],
             "M" => [{0, 1}, {0, 5}, {1, 1}, {1, 5}],
             "A" => [{0, 2}, {0, 6}, {1, 2}, {1, 6}],
             "S" => [{0, 3}, {0, 7}, {1, 3}, {1, 7}]
           }
  end

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
      assert Day4.direction_operator(0, 0, unquote(direction), unquote(distance)) ==
               unquote(expected)
    end
  end

  test "Check direction collector gives correct coords for full XMAS" do
    for {direction, expected} <- [
          {:east, %{"X" => {0, 0}, "M" => {0, 1}, "A" => {0, 2}, "S" => {0, 3}}},
          {:north, %{"X" => {0, 0}, "M" => {-1, 0}, "A" => {-2, 0}, "S" => {-3, 0}}},
          {:northeast, %{"X" => {0, 0}, "M" => {-1, 1}, "A" => {-2, 2}, "S" => {-3, 3}}},
          {:northwest, %{"X" => {0, 0}, "M" => {-1, -1}, "A" => {-2, -2}, "S" => {-3, -3}}},
          {:south, %{"X" => {0, 0}, "M" => {1, 0}, "A" => {2, 0}, "S" => {3, 0}}},
          {:southeast, %{"X" => {0, 0}, "M" => {1, 1}, "A" => {2, 2}, "S" => {3, 3}}},
          {:southwest, %{"X" => {0, 0}, "M" => {1, -1}, "A" => {2, -2}, "S" => {3, -3}}},
          {:west, %{"X" => {0, 0}, "M" => {0, -1}, "A" => {0, -2}, "S" => {0, -3}}}
        ] do
      assert Day4.direction_collector(0, 0, ["X", "M", "A", "S"], direction) == expected
    end
  end

  test "Check accumulated directions are in board" do
    for {directions, expected} <- [
          {%{"X" => {0, 0}, "M" => {0, 1}, "A" => {0, 2}, "S" => {0, 3}}, true},
          {%{"X" => {0, 0}, "M" => {1, 1}, "A" => {0, 2}, "S" => {0, 3}}, false}
        ] do
      assert Day4.collected_points_registered(
               %{
                 "X" => [{0, 0}],
                 "M" => [{0, 1}],
                 "A" => [{0, 2}],
                 "S" => [{0, 3}]
               },
               directions
             ) == expected
    end
  end

  test "Check correct number of valid XMAS detected" do
    assert Day4.collect_valid_directions_from_start(
             %{
               "X" => [{0, 0}],
               "M" => [{0, 1}],
               "A" => [{0, 2}],
               "S" => [{0, 3}]
             },
             0,
             0,
             ["X", "M", "A", "S"],
             [:north, :south, :east, :west, :northeast, :northwest, :southeast, :southwest]
           ) == 1
  end

  test "Check board calculation is correct" do
    input =
      Day4.input_to_map(
        Day4.parse_input(
          "MMMSXXMASM\nMSAMXMSMSA\nAMXSXMAAMM\nMSAMASMSMX\nXMASAMXAMM\nXXAMMXXAMA\nSMSMSASXSS\nSAXAMASAAA\nMAMMMXMMMM\nMXMXAXMASX"
        )
      )

    assert Day4.find_all_xmas_from_x(input, ["X", "M", "A", "S"]) == 18
  end

  test "Check board samples correctly execute with IO" do
    assert Day4.part1("data/day4_sample.txt") == 18
    assert Day4.part2("data/day4_sample.txt") == 9
  end

  test "Check only MAS found as X" do
    input =
      Day4.input_to_map(
        Day4.parse_input(
          "MMMSXXMASM\nMSAMXMSMSA\nAMXSXMAAMM\nMSAMASMSMX\nXMASAMXAMM\nXXAMMXXAMA\nSMSMSASXSS\nSAXAMASAAA\nMAMMMXMMMM\nMXMXAXMASX"
        )
      )

    assert Day4.all_x_s(input) == 9
  end
end
