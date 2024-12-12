defmodule Day1Test do
  use ExUnit.Case

  test "Checking '3   4' converted to integers" do
    assert Day1.string_to_two_integers("3   4") == {3, 4}
  end

  test "Checking '4   3' converted to integers" do
    assert Day1.string_to_two_integers("4   3") == {4, 3}
  end

  test "Checking '1   3' converted to integers" do
    assert Day1.string_to_two_integers("1   3") == {1, 3}
  end

  test "Checking '3   9' converted to integers" do
    assert Day1.string_to_two_integers("3   9") == {3, 9}
  end

  test "Checking '3   3' converted to integers" do
    assert Day1.string_to_two_integers("3   3") == {3, 3}
  end

  test "Checking Day1.add_pair_to_lists [],[] 3,3 becomes [3], [3]" do
    {l_list, r_list} = Day1.add_pair_to_lists({3, 3}, [], [])
    assert l_list == [3]
    assert r_list == [3]
  end

  test "Checking Day1.add_pair_to_lists [1][2] 3,3 becomes [1,3], [2,3]" do
    l_list = [1]
    r_list = [2]
    {l_list, r_list} = Day1.add_pair_to_lists({3, 3}, l_list, r_list)
    assert l_list == [1 | 3]
    assert r_list == [2 | 3]
  end

  test "Checking Strings reduce into two separate " do
    strings = ["3   4", "4   3", "1   3", "3   9", "3   3"]
    {left, right} = Day1.collect_str_ints_to_list(strings)
    assert left == [3, 4, 1, 3, 3]
    assert right == [4, 3, 3, 9, 3]
  end

  test "Checking numeric lists reduce into single sum" do
    left = [3, 4, 2, 1, 3, 3]
    right = [4, 3, 5, 3, 9, 3]
    assert Day1.sort_reduce_subtract(left, right) == 11
  end

  test "Checking file IO works with day1" do
    assert Day1.part1("data/day1_sample.txt") == 11
  end

  test "Checking 3 3's give a similarity of 9" do
    assert Day1.simcount([3 | [3, 3]]) == Map.new(%{3 => 3})
  end

  test "Checking value on left multiplies counts on right" do
    n_map = Day1.simcount([4, 3, 3, 9, 3])
    assert Day1.val_mult(3, n_map) == 9
    assert Day1.val_mult(4, n_map) == 4
    assert Day1.val_mult(2, n_map) == 0
    assert Day1.val_mult(1, n_map) == 0
  end

  test "Checking similarity score sums" do
    n_map = Day1.simcount([4, 3, 3, 9, 3])
    assert Day1.similarity_sum([3, 4, 1, 3, 3], n_map) == 31
  end

  test "Checking file io works for part 2" do
    assert Day1.part2("data/day1_sample.txt") == 31
  end
end
