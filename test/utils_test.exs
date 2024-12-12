defmodule UtilsTest do

  use ExUnit.Case

  for {direction, distance, expected} <- [
    {:north, 1, {-1,0}},
    {:north, 4, {-4,0}},
    {:northeast, 1, {-1,1}},
    {:northwest, 1, {-1,-1}},
    {:south, 1, {1,0}},
    {:southeast, 1, {1,1}},
    {:southwest, 1, {1,-1}},
    {:southwest, 4, {4,-4}},
    {:east, 1, {0,1}},
    {:west, 1, {0,-1}}
  ] do
    test "Check #{direction} direction generates correct results with magnitude #{distance}" do
      assert Utils.direction_operator(0,0,unquote(direction), unquote(distance)) == unquote(expected)
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

  test "Check parse functions properly" do
    assert Utils.parse_string_to_two_tuple(".#.\n.^.") == {{".","#","."},{".","^","."}}
  end

  test "Check get potential next steps" do
    assert Utils.get_pot_next_steps(0,0,[:north, :south, :east, :west], 1) == [
      {-1,0}, {1,0}, {0,1}, {0,-1}
    ]
  end

  test "Check get value from 2d tuple" do
    assert Utils.get_value_from_2d_tuple({{".","#","."},{".","^","."}}, 1,1) == "^"
  end

  test "Print tuple" do
    assert Utils.print_tuple({1,2,3}) == "{1,2,3}"
  end

  test "check generate map" do
    assert Utils.generate_map_from_split_str(".A.\nBB.") == %{"A"=>[{0,1}], "B"=>[{1,0}, {1,1}]}
    assert Utils.generate_map_from_split_str("CAC\nBBD") == %{"A"=>[{0,1}], "B"=>[{1,0}, {1,1}], "C"=>[{0,0},{0,2}], "D"=>[{1,2}]}
  end

end
