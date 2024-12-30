defmodule Day16Test do
  use ExUnit.Case

  test "Check part 1" do
    assert Day16.part1("data/day16_sample1.txt") == 7036
    assert Day16.part1("data/day16_sample2.txt") == 11048
    assert Day16.part1("data/day16_sample3.txt") == 21148
    #assert Day16.part1("data/day16.txt") == 21148
  end
end
