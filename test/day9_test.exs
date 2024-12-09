defmodule Day9Test do

  use ExUnit.Case

  for {input, expected} <- [
    {1,["."]},
    {2,[".","."]},

  ] do
    test "Checking accumulate periods for #{input} expecting #{expected}" do
      assert Day9.accumulate_periods(unquote(input)) == unquote(expected)
    end
  end

  for {input, input2, expected} <- [
    {1,1,[0]},
    {2,9,[9,9]},

  ] do
    test "Checking accumulate letters for #{input} #{input2} expecting #{expected}" do
      assert Day9.accumulate_ids(unquote(input), unquote(input2)) == unquote(expected)
    end
  end

  for {input, input2, expected} <- [
    {1,0,[0]},
    {2,8,[4,4]},
    {2,2,[1,1]},
    {3,4,[2,2,2]},
    {4,6,[3,3,3,3]},
    {0,1,[]},
    {2,3,[".","."]},
    {2,5,[".","."]},
    {3,7,[".",".","."]},
    {4,9,[".",".",".","."]}

  ] do
    test "Checking accumulate letters for #{input} #{input2} expecting #{expected}" do
      assert Day9.accum_correct_value(unquote(input), unquote(input2)) == unquote(expected)
    end
  end


  test "Check build accum" do
    assert Day9.build_accum(String.split("12345", "", trim: true))==[0,".",".",1,1,1,".",".",".",".",2,2,2,2,2]
  end

  test "check correct ignore counts and start index" do
    assert Enum.join(Map.get(Day9.swap_one_digit_at_a_time(
      [0,".",".",1,1,1,".",".",".",".",2,2,2,2,2]
    ),:defrag), "") == "022111222......"
    assert Enum.join(Map.get(Day9.swap_one_digit_at_a_time(
      Day9.build_accum(String.split("2333133121414131402", "", trim: true))
    ),:defrag), "") == "0099811188827773336446555566.............."
  end

  test "Check swap" do
    current_defrag = [0,".",".",1,1,1,".",".",".",".",2,2,2,2,2]
    current_defrag_as_tuple = List.to_tuple(Enum.with_index(current_defrag))
    swap = Day9.swap(current_defrag, elem(current_defrag_as_tuple, 14), 1)
    assert length(swap) == length(current_defrag)
    assert swap == [0,2,".",1,1,1,".",".",".",".",2,2,2,2,"."]
  end

  test "Get accumulated calculation" do
    assert Day9.defrag_to_sum(Day9.swap_one_digit_at_a_time(
      Day9.build_accum(String.split("2333133121414131402", "", trim: true))
    )) == 1928
  end

end
