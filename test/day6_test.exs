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

  test "Check IO with part1" do
    assert Day6.part1("data/day6_sample.txt") == 41
  end

end
