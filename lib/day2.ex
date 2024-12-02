defmodule Day2 do

  def between_1_3(left, right) do
    dist = abs(left-right)
    dist <= 3 and dist >= 1
  end

  def determine_direction(left, right) do
    diff = left - right
    case diff do
      x when x > 0 -> :descent
      x when x < 0 -> :ascent
      x when x == 0 -> :plateau
    end
  end

  def follows_rules(left, right, previous_direction) do
    dir = determine_direction(left, right)
    if dir == :plateau do
      false
    else
      direction_verdict = previous_direction == dir
      distal_verdict = between_1_3(left,right) == true
      direction_verdict == true and distal_verdict == true
    end

  end

  def to_int(int) do
    String.to_integer(int)
  end

  def str_ints_follow_rules(left, right, previous_direction) do
    left_int = to_int(left)
    right_int = to_int(right)
    follows_rules(left_int, right_int, previous_direction)
  end

  def process_str_list_to_int_list(list_ints) do
    List.to_tuple(Enum.map(String.split(list_ints), fn x -> to_int(x) end))
  end

  def string_to_determination(list_ints) do
    if between_1_3(elem(list_ints, 0), elem(list_ints, 1)) == false do
      :unsafe
    else
      previous_direction = determine_direction(elem(list_ints, 0), elem(list_ints, 1))
      index_list = Enum.to_list(1..tuple_size(list_ints)-1)
      all_q = Enum.all?(index_list, fn x -> follows_rules(elem(list_ints, x-1), elem(list_ints, x), previous_direction) end)
      case all_q do
        x when x == true -> :safe
        x when x == false -> :unsafe
      end
    end
  end

  def make_slice(list, index) do
    left_half = Enum.slice(list, 0..index-1)
    right_half = Enum.slice(list, index+1..Enum.count(list))
    left_half++right_half
  end

  @doc """
  Creates a new option runs for a given list by removing an index

  Example: fn([1,2,3], 1)->[1,3]
  """
  def create_options_for_index(list, index) do
    size = Enum.count(list)
    case index do
      x when x == 0 -> Enum.slice(list, 1..size)
      x when x == size - 1 -> Enum.slice(list, 0..size - 2)
      x -> make_slice(list, x)
     end
  end

  @doc """
  Creates all of the options for a given list
  """
  def enumerate_options_for_list(list) do
    Enum.map(Enum.to_list(0..Enum.count(list)-1),fn x -> create_options_for_index(list, x) end)
  end

  @doc """
  Checks the base string and the alternative options to find if atleast 1 is safe.

  """
  def atleast_1_safe(list) do
    lst = process_str_list_to_int_list(list)
    if string_to_determination(lst) == :safe do
      true
    else
      Enum.any?(enumerate_options_for_list(Tuple.to_list(lst)), fn x -> string_to_determination(List.to_tuple(x)) == :safe end)
    end

  end

  def count_safes(list_ints) do
    Enum.reduce(list_ints, 0, fn lst, acc ->
      if string_to_determination(process_str_list_to_int_list(lst)) == :safe do
        acc+1
      else
        acc+0
      end
     end)
  end

  def count_atleast_1_safe(list_ints) do

    Enum.reduce(list_ints, 0, fn lst, acc ->
      if atleast_1_safe(lst) == true do
        acc+1
      else
        acc+0
      end
    end)
  end

  def part1(path) do
    {:ok, contents} = File.read(path)
    count_safes(String.split(contents, "\n", trim: true))
  end

  def part2(path) do
    {:ok, contents} = File.read(path)
    count_atleast_1_safe(String.split(contents, "\n", trim: true))
  end


end
