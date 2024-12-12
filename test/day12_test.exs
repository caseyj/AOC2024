defmodule Day12Test do
  use ExUnit.Case

  test "Check get_letter_neighbors" do
    assert Day12.get_letter_neighbors(1, 1, [{0, 1}, {2, 1}, {1, 2}, {1, 0}]) == [
             {0, 1},
             {2, 1},
             {1, 2},
             {1, 0}
           ]

    assert Day12.get_letter_neighbors(1, 1, [{100, 1}, {2, 1}, {4, 2}, {111, 0}]) == [{2, 1}]
  end

  test "Checking add_to_list_if_missing" do
    assert Day12.add_to_list_if_missing([1, 2, 3], [4]) == [1, 2, 3, 4]
    assert Day12.add_to_list_if_missing([1, 2, 3, 4], [4]) == [1, 2, 3, 4]
    assert Day12.add_to_list_if_missing([], [4]) == [4]
  end

  test "Check halt_when_list_zero" do
    assert Day12.halt_when_list_zero(%{:hello => [], :world => [1, 2]}, :hello) ==
             {:halt, %{:hello => [], :world => [1, 2]}}

    assert Day12.halt_when_list_zero(%{:hello => [], :world => [1, 2]}, :world) ==
             {:cont, %{:hello => [], :world => [1, 2]}}
  end

  test "Check get_polygon_from_starting_point" do
    assert Map.get(
             Day12.get_polygon_from_starting_point({1, 1}, [{0, 1}, {2, 1}, {1, 2}, {1, 0}]),
             :collected
           ) == [{1, 1}, {0, 1}, {2, 1}, {1, 2}, {1, 0}]
  end

  test "Check get_polygons_for_letter" do
    grid_map = %{
      "A" => [{1, 1}, {0, 1}, {2, 1}, {1, 2}, {1, 0}, {5, 5}],
      "O" => [{100, 0}, {101, 0}]
    }

    assert Map.get(Day12.get_polygons_for_letter(grid_map, "A"), :result) == [
             [{1, 1}, {0, 1}, {2, 1}, {1, 2}, {1, 0}],
             [{5, 5}]
           ]

    assert Map.get(Day12.get_polygons_for_letter(grid_map, "O"), :result) == [
             [{100, 0}, {101, 0}]
           ]
  end

  test "Check area" do
    assert Day12.area([{1, 1}, {0, 1}, {2, 1}, {1, 2}, {1, 0}]) == 5
  end

  test "Check perimeter" do
    assert Day12.perimeter([{0, 0}, {0, 1}, {1, 0}, {1, 1}]) == 8
    assert Day12.perimeter([{0, 0}]) == 4
  end

  test "Check cost" do
    assert Day12.cost([{0, 0}, {0, 1}, {1, 0}, {1, 1}]) == 32
  end
end
