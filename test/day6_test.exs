defmodule Day6Test do


  use ExUnit.Case


  for {current_direction, expected} <- [
    {:north, :east},
    {:east, :south},
    {:south, :west},
    {:west, :north}
  ] do
    test "Checks rotate guard with input #{current_direction} expecting #{expected}" do
      assert Day6.rotate_guard(unquote(current_direction)) == unquote(expected)
    end
  end

  for {row, column, expected} <- [
    {0,0,true},
    {0,-1,false},
    {-1,-1,false},
    {-1,0,false},
    {20,20,false},
    {20,19,false},
    {19,20,false},
    {19,19,true},
  ] do
    test "Checks check on map, coordinates #{row},#{column} expected #{expected}" do
      assert Day6.check_on_map(unquote(row), unquote(column), 20,20) == unquote(expected)
    end
  end

  for {input, expected} <- [
    {"#", :block},
    {"^", :guard},
    {".", :ignore},
  ]do
    test "Check spot #{input} is correctly classified as #{expected}" do
      assert Day6.determine_object(unquote(input)) == unquote(expected)
    end
  end

  test "Check parse functions properly" do
    assert Day6.parse_raw(".#.\n.^.") == {{".","#","."},{".","^","."}}
  end

  test "Checks detect_guard_position returns guard position correctly." do
    assert Day6.detect_guard_position({{".","#","."},{".","^","."}, {"#",".","#"}}) == {1,1, :north}
  end

  for {direction, expected} <- [
    {:north, true},
    {:east, true},
    {:west, true},
    {:south, true},
    {:southeast, false},
    {:southwest, false},
    {:northeast, false},
    {:northwest, false}
  ] do
    test "Check is_block correctly identifies a block with input #{direction} and result #{expected}" do
      new_spot = Utils.direction_operator(1, 1, unquote(direction), 1)
      assert Day6.is_block(
        elem(new_spot, 0),
        elem(new_spot, 1),
        {{".","#","."},{"#","^","#"}, {".","#","."}}) == unquote(expected)
    end
  end

  for {direction, expected} <- [
    {:north, :west},
    {:west, :south},
    {:south, :east},
    {:east, :north}
  ]do
    test "Check rotation to identify previous position is corrent for #{direction} expecting #{expected}" do
      assert Day6.previous_rotation(unquote(direction)) == unquote(expected)
    end
  end

  test "Check find_block() works" do
    assert Day6.find_block([{0,0}, {0,1}, {0,2}, {0,3}], {{".",".","#"},{".",".","#"},{"#","#","#"}, {".","#","#"}}) == {0,2}
    assert Day6.find_block([{0,0}, {1,0}, {2,0}, {3,0}], {{".",".","#"},{".",".","#"},{".","#","#"}, {".","#","#"}}) == nil
  end

  test "Check find_span() works" do
    assert Day6.find_span([{0,0}, {0,1}, {0,2}, {0,3}], {{".",".","#"},{".",".","#"},{"#","#","#"}, {".","#","#"}}) == [{0,0}, {0,1}]
    assert Day6.find_span([{0,0}, {1,0}, {2,0}, {3,0}], {{".",".","#"},{".",".","#"},{".","#","#"}, {".","#","#"}}) == [{0,0}, {1,0}, {2,0}, {3,0}]
  end

  test "Check get_next_directions" do
    assert Day6.get_next_directions(3,0,:north,{{".",".","#"},{".",".","#"},{"#","#","#"}, {".","#","#"}}) == [{2,0},{1,0},{0,0}]
    assert Day6.get_next_directions(0,0,:east,{{".",".","#"},{".",".","#"},{"#","#","#"}, {".","#","#"}}) == [{0,1},{0,2},{0,3}]
    assert Day6.get_next_directions(0,3,:west,{{".",".","#"},{".",".","#"},{"#","#","#"}, {".","#","#"}}) == [{0,2},{0,1},{0,0}]
    assert Day6.get_next_directions(0,0,:south,{{".",".","#"},{".",".","#"},{"#","#","#"}, {".","#","#"}}) == [{1,0},{2,0},{3,0}]
  end

  test "Check get_next_directions and find_span gives expected span" do
    matrix = {{".",".","."},{".",".","#"},{"#",".","#"}, {".",".","#"}}
    assert Day6.find_span(Day6.get_next_directions(2,1,:north, matrix), matrix) == [{1,1}, {0,1}]
    assert Day6.find_span(Day6.get_next_directions(0,1,:south, matrix), matrix) == [{1,1}, {2,1}, {3,1}]
    assert Day6.find_span(Day6.get_next_directions(1,0,:east, matrix), matrix) == [{1,1}]
    assert Day6.find_span(Day6.get_next_directions(0,2,:west, matrix), matrix) == [{0,1},{0,0}]
  end

  test "Check correct detection of block causing turn" do
    assert Day6.detect_block_causing_turns([{1,0,:north},{1,0,:east}]) == [{1,0, :north}]
  end


  test "Check IO with part1" do
    assert Day6.part1("data/day6_sample.txt") == 41
    #assert Day6.part2("data/day6_sample.txt") == 6
  end

end
