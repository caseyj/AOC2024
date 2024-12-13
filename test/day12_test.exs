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
    assert Day12.get_polygon_from_starting_point([{1, 1}], [], [{1, 1}], [
             {0, 1},
             {2, 1},
             {1, 2},
             {1, 0}
           ]) == [{1, 1}, {0, 1}, {2, 1}, {1, 2}, {1, 0}]
  end

  test "Check get_polygons_for_letter" do
    grid_map = %{
      "A" => [{1, 1}, {0, 1}, {2, 1}, {1, 2}, {1, 0}, {5, 5}],
      "O" => [{100, 0}, {101, 0}],
      "R" => [
        {0, 0},
        {0, 1},
        {0, 2},
        {0, 3},
        {1, 0},
        {1, 1},
        {1, 2},
        {1, 3},
        {2, 2},
        {2, 3},
        {2, 4},
        {3, 3}
      ]
    }

    assert Map.get(Day12.get_polygons_for_letter(grid_map, "A"), :result) == [
             [{1, 1}, {0, 1}, {2, 1}, {1, 2}, {1, 0}],
             [{5, 5}]
           ]

    assert Map.get(Day12.get_polygons_for_letter(grid_map, "O"), :result) == [
             [{100, 0}, {101, 0}]
           ]

    assert Map.get(Day12.get_polygons_for_letter(grid_map, "R"), :result) == [
             [
               {0, 0},
               {1, 0},
               {0, 1},
               {1, 1},
               {0, 2},
               {1, 2},
               {0, 3},
               {2, 2},
               {1, 3},
               {2, 3},
               {3, 3},
               {2, 4}
             ]
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

  for {letter, polygon, perimeter, area, cost} <- [
        {"A", [{0, 0}, {0, 1}, {0, 2}, {0, 3}], 10, 4, 40},
        {"B", [{1, 0}, {2, 0}, {1, 1}, {2, 1}], 8, 4, 32},
        {"C", [{1, 2}, {2, 2}, {2, 3}, {3, 3}], 10, 4, 40},
        {"D", [{1, 3}], 4, 1, 4},
        {"E", [{3, 0}, {3, 1}, {3, 2}], 8, 3, 24}
      ] do
    test "Check functions with sample inputs for letter #{letter}" do
      matrix_str = "AAAA\nBBCD\nBBCC\nEEEC"
      matrix = Utils.generate_map_from_split_str(matrix_str)
      polygons = hd(Map.get(Day12.get_polygons_for_letter(matrix, unquote(letter)), :result))
      assert polygons == unquote(polygon)
      assert Day12.perimeter(polygons) == unquote(perimeter)
      assert Day12.area(polygons) == unquote(area)
      assert Day12.cost(polygons) == unquote(cost)
    end
  end

  for {letter, expected} <- [
        {"R", 216},
        {"F", 180},
        {"V", 260},
        {"J", 220},
        {"E", 234},
        {"M", 60},
        {"S", 24}
      ] do
    test "Check larger example, just letter #{letter} and cost #{expected}" do
      matrix_str =
        "RRRRIICCFF\nRRRRIICCCF\nVVRRRCCFFF\nVVRCCCJFFF\nVVVVCJJCFE\nVVIVCCJJEE\nVVIIICJJEE\nMIIIIIJJEE\nMIIISIJEEE\nMMMISSJEEE"

      matrix = Utils.generate_map_from_split_str(matrix_str)
      polygons = Map.get(Day12.get_polygons_for_letter(matrix, unquote(letter)), :result)
      assert Day12.all_region_cost(polygons) == unquote(expected)
    end
  end

  test "Check total cost" do
    matrix_str =
      "RRRRIICCFF\nRRRRIICCCF\nVVRRRCCFFF\nVVRCCCJFFF\nVVVVCJJCFE\nVVIVCCJJEE\nVVIIICJJEE\nMIIIIIJJEE\nMIIISIJEEE\nMMMISSJEEE"

    matrix = Utils.generate_map_from_split_str(matrix_str)
    assert Day12.total_cost(matrix) == 1930
  end
end
