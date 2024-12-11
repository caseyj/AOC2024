defmodule Day11 do

  @spec stone_split(binary()) :: list()
  def stone_split(stone_str) do
    split_val = div(String.length(stone_str),2)
    Enum.map(Tuple.to_list(String.split_at(stone_str, split_val)), fn x -> Utils.to_int(x) end)
  end

  @spec stone_digits(binary()) :: boolean()
  def stone_digits(stone) do
    rem(String.length(stone),2)==0
  end

  @spec stone_response(integer()) :: list()
  def stone_response(stone_number) do
    if stone_number == 0 do
      [1]
    else
      stone_str = "#{stone_number}"
      if stone_digits(stone_str) do
        stone_split(stone_str)
      else
        [stone_number*2024]
      end
    end
  end

  def memoize(memo, stone, result) do
    %{:result=>Map.get(memo, :result),
    :memo=>Map.put(Map.get(memo, :memo), stone, result)}
  end

  def check_if_memo_has_stone(memo, stone) do
    Map.has_key?(Map.get(memo, :memo), stone)
  end

  def add_stone_to_results_list(memo, result) do
    Utils.map_append_lists(memo, :result, result)
  end

  def get_memoized_value(memo, stone) do
    Map.get(Map.get(memo, :memo), stone)
  end

  def stone_line(memo) do
    Enum.reduce(Map.get(memo, :result), %{:result=>[], :memo=>Map.get(memo, :memo)}, fn stone, acc ->
    if check_if_memo_has_stone(acc, stone) do
      add_stone_to_results_list(acc, get_memoized_value(acc, stone))
    else
      result = stone_response(stone)
      memoize(add_stone_to_results_list(acc, result), stone, result)
    end
    end)
  end

  def blink_n_times(memo,blinks) do
    if blinks == 0 do
      memo
    else
      blink_n_times(stone_line(memo), blinks-1)
    end
  end

def part1(filename) do
  part1(filename, 25)
end

  def part1(filename,blink_count) do
    {:ok, content} = File.read(filename)
    Map.get(Enum.reduce(
      Enum.map(
        String.split(content, " ", trim: true),
        fn x -> Utils.to_int(x) end),
      %{:result=>0, :memo=>%{}},
      fn number, acc ->
        blinked = blink_n_times(%{:result=>[number], :memo=>Map.get(acc, :memo)}, blink_count)
        count = Enum.count(Map.get(blinked, :result))
        %{:result=>Map.get(acc, :result)+count, :memo=>Map.get(blinked, :memo)}
      end
    ), :result)
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)
    part1(filename, 75)
  end

end
