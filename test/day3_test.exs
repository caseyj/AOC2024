defmodule Day3Test do
  use ExUnit.Case

  for {input_str, expected}<-[
    {"mul(1,2)", [["mul(1,2)","mul(1,2)"]]},
    {"mul(4*, mul(6,9!, ?(12,34)", []},
    {"mul ( 2 , 4 )", []},
    {"xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))", [["mul(2,4)", "mul(2,4)"],
      ["mul(5,5)", "mul(5,5)"],
      ["mul(11,8)", "mul(11,8)"],
      ["mul(8,5)", "mul(8,5)"]
      ]}

  ] do
    test "Check input strin #{input_str} recognized by pattern (mul\(\d+,\d+\)) , and has #{Enum.count(expected)}" do
      assert Day3.scan_str_w_pat(unquote(input_str)) == unquote(expected)
    end
  end

  for {input_str, expected}<-[
    {"mul(1,2)", 2},
    {"mul(44,46)", 2024},
    {"mul(123,4)", 492}
  ] do
    test "Check input strin #{input_str} recognized by pattern \((?<left>\d+),(?<right>\d+)\) , and equals #{expected}" do
      assert Day3.parse_mult_components(unquote(input_str)) == unquote(expected)
    end
  end

  test "Check sum of multiplied data" do
    assert Day3.get_sum_big_str(Day3.scan_str_w_pat("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")) == 161
  end

  test "Check new regex output gives right list" do
    assert Day3.scan_str_w_do_dont("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")== [
    ["mul(2,4)", "mul(2,4)"],
    ["don't()", "don't()"],
    ["mul(5,5)", "mul(5,5)"],
    ["mul(11,8)", "mul(11,8)"],
    ["do()", "do()"],
    ["mul(8,5)", "mul(8,5)"]
    ]
  end

  test "Check correct list of operations selected" do
    assert Day3.until_dont(Day3.scan_str_w_do_dont("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")) == [
      ["mul(2,4)", "mul(2,4)"],
      ["do()", "do()"],
      ["mul(8,5)", "mul(8,5)"]
    ]
  end

  test "Check file IO works properly" do
    assert Day3.part1("data/day3_sample.txt") == 161
    assert Day3.part2("data/day3_sample2.txt") == 48
  end

end
