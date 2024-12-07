defmodule Day7Test do

  use ExUnit.Case

  test "Check parse functions work" do
    assert Day7.parse_line_to_components("190: 10 19\n") == ["190", " 10 19\n"]
    assert Day7.parse_string_components(" 10 19") == {10, 19}
  end

  test "Check build options correctly generated" do
    assert Day7.build_options(10, 19, 1, [:sum, :mult]) == [{10, 19, :sum, 1},{10, 19, :mult, 1}]
    assert Day7.build_options(10, 19, 1, [:sum, :mult, :cat]) == [{10, 19, :sum, 1},{10, 19, :mult, 1}, {10, 19, :cat, 1}]
  end

  test "Check operation decider functions properly" do
    assert Day7.operation_decider(10, 19, :sum) == 29
    assert Day7.operation_decider(10, 19, :mult) == 190
    assert Day7.operation_decider(10, 19, :cat) == 1019
  end

  test "Check operation runner comes up with correct values" do
    assert Day7.operation_runner(190,{10,19},[:sum, :mult]) == true
    assert Day7.operation_runner(3267,{81, 40, 27},[:sum, :mult]) == true
    assert Day7.operation_runner(292, {11, 6, 16, 20},[:sum, :mult]) == true
    assert Day7.operation_runner(83, {17, 5},[:sum, :mult]) == false
    assert Day7.operation_runner(156,{15, 6},[:sum, :mult]) == false
    assert Day7.operation_runner(7290, {6, 8, 6, 15},[:sum, :mult]) == false
    assert Day7.operation_runner(161011, {16, 10, 13},[:sum, :mult]) == false
    assert Day7.operation_runner(192, {17, 8, 14},[:sum, :mult]) == false
    assert Day7.operation_runner(21037, {9, 7, 18, 13},[:sum, :mult]) == false

    assert Day7.operation_runner(156,{15, 6},[:sum, :mult, :cat]) == true
    assert Day7.operation_runner(7290, {6, 8, 6, 15},[:sum, :mult, :cat]) == true
    assert Day7.operation_runner(161011, {16, 10, 13},[:sum, :mult, :cat]) == false
    assert Day7.operation_runner(192, {17, 8, 14},[:sum, :mult, :cat]) == true
    assert Day7.operation_runner(21037, {9, 7, 18, 13},[:sum, :mult, :cat]) == false
  end

  test "Check sample is successful" do
    assert Day7.part1("data/day7_sample.txt") ==3749
    assert Day7.part2("data/day7_sample.txt") ==11387
  end

end
