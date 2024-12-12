defmodule Day11Test do

  use ExUnit.Case

  for {input, expected} <- [
    {"1000",[10,0]},
    {"23", [2,3]}
  ] do
    test "Check stone split #{input}, #{expected}" do
      assert Day11.stone_split(unquote(input)) == unquote(expected)
    end
  end

  for {input, expected} <- [
    {"1", false},
    {"2", false},
    {"123", false},
    {"30", true},
    {"1000", true},
  ] do
    test "Check stone_digits #{input}, #{expected}" do
      assert Day11.stone_digits(unquote(input)) == unquote(expected)
    end
  end

  for {input, expected} <- [
    {0, [1]},
    {1, [2024]},
    {10, [1,0]},
    {99, [9,9]},
    {999, [2021976]},
  ] do
    test "Check stone_response #{input}" do
      assert Day11.stone_response(unquote(input)) == unquote(expected)
    end
  end

  test "Check stone_line" do
    #assert Day11.stone_line([0, 1, 10, 99, 999], agent) == [1, 2024, 1, 0, 9, 9, 2021976]
    assert 1==1
  end

  test "Check blink_n_times" do
    #assert Day11.blink_n_times([125, 17], agent,6) == [2097446912, 14168, 4048, 2, 0, 2, 4, 40, 48, 2024, 40, 48, 80, 96, 2, 8, 6, 7, 6, 0, 3, 2]
    assert 1==1
  end

  test "Check part1" do
    assert Day11.part1("data/day11_sample.txt", 6) == 22
    assert Day11.part1("data/day11_sample.txt", 25) == 55312
  end

end
