defmodule Day15Test do

  use ExUnit.Case

  for {input, box_list, expected} <- [
    {{1,1},[], [{2,1}]},
    {{2,1},[{3,1}], [{3,1}, {4,1}]},
    {{3,1},[{4,1}, {5,1}], [{4,1}, {5,1}, {6,1}]},
  ] do
    test "Check box collision #{Utils.print_tuple(input)}" do
      assert Day15.box_collision(unquote(input), "v", unquote(box_list)) == unquote(expected)
    end
  end

  for {str ,collisons, box_list, expected} <- [
    {"no collision", [{2,1}],[{3,5}], {{2,1},[{3,5}]}},
    {"1 collision", [{2,1},{3,1}],[{2,1},{3,5}], {{2,1},[{3,5}, {3,1}]}},
    {"2 collision", [{2,1},{3,1},{4,1}],[{2,1},{3,1},{4,1},{3,5}], {{2,1},[{3,1},{4,1},{3,5}]}}
  ] do
    test "Check update_box_list #{str}" do
      assert Day15.update_box_list(unquote(collisons), unquote(box_list)) == unquote(expected)
    end
  end

  test "Check wall_collision" do
    assert Day15.wall_collision([{1,1}], [{2,1},{3,5}]) == false
    assert Day15.wall_collision([{1,1}], [{1,1},{3,5}]) == true
    assert Day15.wall_collision([{1,1},{2,1},{3,1},{4,1}], [{4,1},{3,5}]) == true
  end

  for {str ,start_coord, box_list, wall_list,expected} <- [
    {"no collision", {1,1},[{3,5}], [], {{2,1},[{3,5}]}},
    {"1 collision", {1,1},[{2,1},{3,5}],[], {{2,1},[{3,5}, {3,1}]}},
    {"2 collision", {1,1},[{2,1},{3,1},{4,1},{3,5}], [],{{2,1},[{3,1},{4,1},{3,5}, {5,1}]}},
    {"wall collision", {1,1},[{2,1},{3,1},{4,1},{3,5}], [{4,1}],{{1,1},[{2,1},{3,1},{4,1},{3,5}]}}
  ] do
    test "Check determine_list #{str}" do
      assert Day15.determine_list(unquote(start_coord), "v", unquote(wall_list),unquote(box_list)) == unquote(expected)
    end
  end

  test "Check intake" do
    intaken_data = Day15.intake("########\n#..O.O.#\n##@.O..#\n#...O..#\n#.#.O..#\n#...O..#\n#......#\n########\n\n<^^>>>vv<v>>v<<")
    assert elem(intaken_data,1) == ["<","^","^",">",">",">","v","v","<","v",">",">","v","<","<"]
    assert Map.get(elem(intaken_data, 0), "@") == [{2,2}]
    assert length(Map.get(elem(intaken_data, 0), "#")) == 30
    assert length(Map.get(elem(intaken_data, 0), "O")) == 6
  end


  test "Check box movement small version works" do
    intaken_data = Day15.intake("########\n#..O.O.#\n##@.O..#\n#...O..#\n#.#.O..#\n#...O..#\n#......#\n########\n\n<^^>>>vv<v>>v<<")
    assert Day15.get_coordinate_sums(Day15.run_instructions(intaken_data)) == 2028
  end

  test "Large and small examples" do
    assert Day15.part1("data/day15_sample1.txt") == 2028
    assert Day15.part1("data/day15_sample2.txt") == 10092
  end


end
