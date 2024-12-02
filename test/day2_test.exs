defmodule Day2Test do
  use ExUnit.Case

  for {left, right, expected}<-[
    {1,2,true},
    {1,3,true},
    {0,4,false},
    {-1, 1, true},
    {-5,-5, false},
    {5,-5, false},
    {5,4,true},
    {5,-4, false},
    {2,7, false}
    ] do
    test "Check between 1 and 3 #{left} #{right}" do
      assert Day2.between_1_3(unquote(left), unquote(right)) == unquote(expected)
    end
  end

  for {left, right, expected}<-[{1,2,:ascent},{5,4,:descent},{5,5, :plateau}] do
    test "Check ascent descent #{left} #{right}" do
      assert Day2.determine_direction(unquote(left), unquote(right)) == unquote(expected)
    end
  end

  for {left, right, previous_direction, expected}<-[
    {1,2,:ascent, true},
    {1,2,:descent, false},
    {5,4,:descent, true},
    {5,4,:ascent, false},
    {5,5, :ascent, false},
    {5,5, :descent, false},
  ] do
    test "Check follows rules #{left} #{right} #{previous_direction}" do
      assert Day2.follows_rules(unquote(left), unquote(right), unquote(previous_direction)) == unquote(expected)
    end
  end

  for {left, right, previous_direction, expected}<-[
    {"1","2",:ascent, true},
    {"1","2",:descent, false},
    {"5","4",:descent, true},
    {"5","4",:ascent, false},
    {"5","5", :ascent, false},
    {"5","5", :descent, false},
    {"8","6", :descent, true},
    {"6","4", :descent, true},
    {"4","4", :descent, false},
    {"4","4", :plateau, false},
    {"4","1", :plateau, false}
  ] do
    test "Check strings follows rules #{left} #{right} #{previous_direction}" do
      assert Day2.str_ints_follow_rules(unquote(left), unquote(right), unquote(previous_direction)) == unquote(expected)
    end
  end

  for {name, list_ints, expected}<-[
    ["7 6 4 2 1", {7, 6, 4, 2, 1}, :safe],
    ["1 2 7 8 9",{1, 2, 7, 8, 9}, :unsafe],
    ["9 7 6 2 1",{9, 7, 6, 2, 1}, :unsafe],
    ["1 3 2 4 5",{1, 3, 2, 4, 5}, :unsafe],
    ["8 6 4 4 1",{8, 6, 4, 4, 1}, :unsafe],
    ["1 3 6 7 9",{1, 3, 6, 7, 9}, :safe]
  ] do
    test "Check each layer gives the right rating #{name}  #{expected}" do
       assert Day2.string_to_determination(unquote(list_ints)) == unquote(expected)
    end
  end

  test "Check string counting results in a sum of 2" do
    assert Day2.count_safes([
      "7 6 4 2 1",
      "1 2 7 8 9",
      "9 7 6 2 1",
      "1 3 2 4 5",
      "8 6 4 4 1",
      "1 3 6 7 9"
      ]) == 2
  end

for {list, index, expected} <- [
  {[1,2,3], 1, [1,3]},
  {[1,2,3], 2, [1,2]},
  {[1,2,3], 0, [2,3]},
]do
  test "Checking create_options_for_index #{index}, with inputs #{Enum.join(list, ",")}" do
    assert Day2.create_options_for_index(unquote(list), unquote(index)) == unquote(expected)
  end
end

  test "Checking all optional indexes generated " do
    assert Day2.enumerate_options_for_list([1,2,3]) == [[2,3],[1,3], [1,2]]
  end

  for {list_ints, expected}<-[
    {"7 6 4 2 1", true},
    {"1 2 7 8 9", false},
    {"9 7 6 2 1", false},
    {"1 3 2 4 5", true},
    {"8 6 4 4 1", true},
    {"1 3 6 7 9", true}
  ] do
    test "Check each layer options are correctly processed #{list_ints} #{expected}" do
      assert Day2.atleast_1_safe(unquote(list_ints)) == unquote(expected)
    end
  end

  test "Check string counting results in a sum of 4" do
    assert Day2.count_atleast_1_safe([
      "7 6 4 2 1",
      "1 2 7 8 9",
      "9 7 6 2 1",
      "1 3 2 4 5",
      "8 6 4 4 1",
      "1 3 6 7 9"
      ]) == 4
  end


  test "check file io works with day2 part 1" do
    assert Day2.part1("data/day2_sample.txt") == 2
    assert Day2.part1("data/day2.txt") == 421
    assert Day2.part2("data/day2_sample.txt") == 4
  end


end
