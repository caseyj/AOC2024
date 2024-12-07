defmodule Day7 do


  @doc """
  Takes a line and produces a 2, list
  """
  def parse_line_to_components(str) do
    String.split(str, ":", trim: true)
  end

  @doc """
  Takes the equation side components and makes a tuple of integers containing them
  """
  def parse_string_components(str) do
    List.to_tuple(Enum.map(String.split(str, " ", trim: true), fn x -> Utils.to_int(x) end))
  end

  @doc """
  produces a sum for 2 values
  """
  def sum(val1,val2) do
    val1+val2
  end

  def mult(val1,val2) do
    val1*val2
  end

  def cat(val1, val2) do
    Utils.to_int("#{val1}#{val2}")
  end

  def operation_decider(val1, val2, op) do
    case op do
      x when x == :sum -> sum(val1,val2)
      x when x == :mult -> mult(val1,val2)
      x when x == :cat -> cat(val1,val2)
    end
  end

  def build_options(val1,val2, index, options_list) do
    Enum.map(options_list, fn x -> {val1, val2, x, index} end)
  end

  def l_one_dist(target, val) do
    target-elem(val,0)
  end

  def operation_runner(target_value, input_tuple,remaining_operations, options_list) do
    if remaining_operations == [] do
      false
    else
      next_op = hd(remaining_operations)
      result = operation_decider(elem(next_op, 0), elem(next_op, 1), elem(next_op, 2))
      if result == target_value do
        true
      else
        starting_index = elem(next_op, 3)
        n_index = starting_index+1
        if n_index < tuple_size(input_tuple) do
          options = tl(remaining_operations)++build_options(result, elem(input_tuple, n_index), n_index, options_list)
          operation_runner(target_value, input_tuple, Enum.sort(options, &(l_one_dist(target_value, &1) <= l_one_dist(target_value,&2))) , options_list)
        else
          operation_runner(target_value, input_tuple, tl(remaining_operations), options_list)
        end
      end
    end
  end

  def operation_runner(target_value, input_tuple, options_list) do
    operation_runner(target_value, input_tuple, build_options(elem(input_tuple,0), elem(input_tuple,1), 1, options_list), options_list)
  end

  def numeric_components_tuple(str) do
    comps = parse_line_to_components(str)
    left_side = Utils.to_int(hd(comps))
    right_side = parse_string_components(hd(tl(comps)))
    {left_side, right_side}
  end

  def convert_input_str_to_list(str) do
    Enum.reduce(String.split(str, "\n", trim: true), [], fn line,acc ->
      acc++[numeric_components_tuple(line)]
    end)
  end

  def count_successful_operations(lines, options_list, correctness_tracker) do
    Enum.reduce(lines, correctness_tracker, fn line, acc ->
        left_side = elem(line, 0)
        right_side = elem(line, 1)
        result = operation_runner(left_side, right_side, options_list)
        if result do
          upd = Map.get(acc, :correct)++[{left_side, right_side}]
          Map.put(acc, :correct, upd)
        else
          upd = Map.get(acc, :incorrect)++[{left_side, right_side}]
          Map.put(acc, :incorrect, upd)
        end
      end)

  end

  def count_correct(correct_map) do
    Enum.reduce(Map.get(correct_map, :correct), 0, fn x, acc -> acc+ elem(x,0) end)
  end



  def part1(filename) do
    {:ok, content} = File.read(filename)

    count_correct(count_successful_operations(convert_input_str_to_list(content), [:sum, :mult], %{:correct=>[],:incorrect=>[]}))
  end
  def part2(filename) do
    {:ok, content} = File.read(filename)
    correctness_tracker = %{:correct=>[],:incorrect=>[]}
    parsed_input = convert_input_str_to_list(content)
    initial_correct_track = count_successful_operations(parsed_input, [:sum, :mult], correctness_tracker)
    cats_only = count_successful_operations(Map.get(initial_correct_track, :incorrect), [:sum, :mult, :cat], correctness_tracker)
    count_correct(initial_correct_track)+count_correct(cats_only)
  end

end
