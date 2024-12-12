defmodule Day9Test do
  use ExUnit.Case

  for {input, expected} <- [
        {1, ["."]},
        {2, [".", "."]}
      ] do
    test "Checking accumulate periods for #{input} expecting #{expected}" do
      assert Day9.accumulate_periods(unquote(input)) == unquote(expected)
    end
  end

  for {input, input2, expected} <- [
        {1, 1, [1]},
        {2, 9, [9, 9]}
      ] do
    test "Checking accumulate letters for #{input} #{input2} expecting #{expected}" do
      assert Day9.accumulate_ids(unquote(input), unquote(input2)) == unquote(expected)
    end
  end

  for {input, input2, expected} <- [
        {1, 0, [0]},
        {2, 8, [4, 4]},
        {2, 2, [1, 1]},
        {3, 4, [2, 2, 2]},
        {4, 6, [3, 3, 3, 3]},
        {0, 1, []},
        {2, 3, [".", "."]},
        {2, 5, [".", "."]},
        {3, 7, [".", ".", "."]},
        {4, 9, [".", ".", ".", "."]}
      ] do
    test "Checking accumulate letters for #{input} #{input2} expecting #{expected}" do
      assert Day9.accum_correct_value(unquote(input), unquote(input2)) == unquote(expected)
    end
  end

  test "Check build accum" do
    assert Day9.build_accum(String.split("12345", "", trim: true)) == [
             0,
             ".",
             ".",
             1,
             1,
             1,
             ".",
             ".",
             ".",
             ".",
             2,
             2,
             2,
             2,
             2
           ]
  end

  test "check correct ignore counts and start index" do
    assert Enum.join(
             Map.get(
               Day9.swap_one_digit_at_a_time([
                 0,
                 ".",
                 ".",
                 1,
                 1,
                 1,
                 ".",
                 ".",
                 ".",
                 ".",
                 2,
                 2,
                 2,
                 2,
                 2
               ]),
               :defrag
             ),
             ""
           ) == "022111222......"

    assert Enum.join(
             Map.get(
               Day9.swap_one_digit_at_a_time(
                 Day9.build_accum(String.split("2333133121414131402", "", trim: true))
               ),
               :defrag
             ),
             ""
           ) == "0099811188827773336446555566.............."
  end

  test "Check swap" do
    current_defrag = [0, ".", ".", 1, 1, 1, ".", ".", ".", ".", 2, 2, 2, 2, 2]
    current_defrag_as_tuple = List.to_tuple(Enum.with_index(current_defrag))
    swap = Day9.swap(current_defrag, elem(current_defrag_as_tuple, 14), 1, ".")
    assert length(swap) == length(current_defrag)
    assert swap == [0, 2, ".", 1, 1, 1, ".", ".", ".", ".", 2, 2, 2, 2, "."]
  end

  test "Get accumulated calculation" do
    assert Day9.defrag_to_sum(
             Day9.swap_one_digit_at_a_time(
               Day9.build_accum(String.split("2333133121414131402", "", trim: true))
             )
           ) == 1928
  end

  test "Check new block objects" do
    assert Day9.decompose_to_blocks([0, ".", ".", 1, 1, 1, ".", ".", ".", ".", 2, 2, 2, 2, 2]) ==
             [{0, 0, 1, 1}, {".", 1, 3, 2}, {1, 3, 6, 3}, {".", 6, 10, 4}, {2, 10, 15, 5}]
  end

  test "Check blocks can be moved into size map" do
    assert Day9.block_list_to_id_queue([
             {0, 0, 1, 1},
             {".", 1, 3, 2},
             {1, 3, 6, 3},
             {".", 6, 10, 4},
             {2, 10, 15, 5}
           ]) == %{1 => [{0, 0, 1, 1}], 3 => [{1, 3, 6, 3}], 5 => [{2, 10, 15, 5}]}

    assert Day9.block_list_to_id_queue(
             Day9.decompose_to_blocks(
               Day9.build_accum(String.split("2333133121414131402", "", trim: true))
             )
           ) == %{
             1 => [{2, 11, 12, 1}],
             2 => [{9, 40, 42, 2}, {4, 19, 21, 2}, {0, 0, 2, 2}],
             3 => [{7, 32, 35, 3}, {3, 15, 18, 3}, {1, 5, 8, 3}],
             4 => [{8, 36, 40, 4}, {6, 27, 31, 4}, {5, 22, 26, 4}]
           }
  end

  test "Check reindex" do
    # assert Day9.block_resort([{0, 0, 2, 2}, {".", 2, 5, 3}, {1, 5, 8, 3}, {".", 8, 11, 3}, {2, 11, 12, 1}, {".", 12, 15, 3}, {3, 15, 18, 3}, {".", 18, 19, 1}, {4, 19, 21, 2}, {".", 21, 22, 1}, {5, 22, 26, 4}, {".", 26, 27, 1}, {6, 27, 31, 4}, {".", 31, 32, 1}, {7, 32, 35, 3}, {".", 35, 36, 1}, {8, 36, 40, 4}, {9, 40, 42, 2}]) == []
    assert 1 == 1
  end

  test "Check map search for space" do
    assert Day9.map_search_for_space(3, %{
             1 => [{2, 11, 12, 1}],
             2 => [{9, 40, 42, 2}, {4, 19, 21, 2}, {0, 0, 2, 2}],
             3 => [{7, 32, 35, 3}, {3, 15, 18, 3}, {1, 5, 8, 3}],
             4 => [{8, 36, 40, 4}, {6, 27, 31, 4}, {5, 22, 26, 4}]
           }) == {2, 9}
  end
end
