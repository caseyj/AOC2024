defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  @doc """
  Turns a string in the format of 'number number' into two numbers in a tuple.
  """
  @spec string_to_two_integers(binary()) :: {integer(), integer()}
  def string_to_two_integers(str) do
    halves_list = String.split(str)
    halves_tuple = List.to_tuple(halves_list)
    {String.to_integer(elem(halves_tuple, 0)), String.to_integer(elem(halves_tuple, 1))}
  end

  @doc """
  Adds a pair of integers to their respective lists
  """
  def add_pair_to_lists(pair, lhlist \\ [], rhlist \\ []) do
    if lhlist == [] do
      lhlist = [elem(pair, 0)]
      rhlist = [elem(pair, 1)]
      {lhlist, rhlist}
    else
      lhlist = lhlist ++ elem(pair, 0)
      rhlist = rhlist ++ elem(pair, 1)
      {lhlist, rhlist}
    end
  end

  @doc """
  """
  def get_full_list([head | tail], index, collector \\ []) do
    if collector == [] do
      get_full_list(tail, index, [elem(head, index)])
    else
      collector = collector ++ [elem(head, index)]

      if tail == [] do
        collector
      else
        get_full_list(tail, index, collector)
      end
    end
  end

  def get_full_list([]) do
    []
  end

  @doc """

  """
  def collect_str_ints_to_list(strs) do
    converted = Enum.map(strs, fn x -> string_to_two_integers(x) end)
    left = get_full_list(converted, 0, [])
    right = get_full_list(converted, 1, [])
    {left, right}
  end

  def distance(left_int, right_int) do
    abs(left_int - right_int)
  end

  def sort_reduce_subtract(left_list, right_list) do
    Enum.zip_reduce(
      Enum.sort(left_list),
      Enum.sort(right_list),
      0,
      fn x, y, acc -> acc + distance(x, y) end
    )
  end

  @spec simcount(any()) :: {list(), any()}
  def simcount(value_lst) do
    Enum.reduce(value_lst, Map.new(), fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def val_mult(val, count_map) do
    count = Map.get(count_map, val, 0)
    val * count
  end

  def similarity_sum(key_list, count_map) do
    Enum.reduce(key_list, 0, fn x, acc -> acc + val_mult(x, count_map) end)
  end

  def part1(path) do
    {:ok, contents} = File.read(path)
    {left, right} = collect_str_ints_to_list(String.split(contents, "\n", trim: true))
    sort_reduce_subtract(left, right)
  end

  def part2(path) do
    {:ok, contents} = File.read(path)
    {left, right} = collect_str_ints_to_list(String.split(contents, "\n", trim: true))
    count_map = simcount(right)
    similarity_sum(left, count_map)
  end
end
