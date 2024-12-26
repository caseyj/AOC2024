defmodule Day25Test do

  use ExUnit.Case

  test "Sum lists" do
    assert Day25.sum_lists([1,2,3], [4,5,6]) == [5,7,9]
  end


  test "get_codes_for_board" do
    assert Day25.get_codes_for_board("#####\n.####\n.####\n.####\n.#.#.\n.#...\n.....") == [0,5,3,4,3]
  end


  test "check count pairs" do
    {:ok, content} = File.read("data/day25_sample.txt")
    assert Day25.count_pairs(Day25.parse_locks_and_keys(content)) == 3
  end

end
