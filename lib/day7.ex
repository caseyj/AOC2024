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

  def operation_decider(val1, val2, op) do
    case op do
      x when x == :sum -> sum(val1,val2)
      x when x == :mult -> mult(val1,val2)
    end
  end

  def build_options(val1,val2, index) do
    [{val1, val2, :sum, index},{val1,val2,:mult, index}]
  end

  def operation_runner(target_value, input_tuple,remaining_operations) do
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
          options = build_options(result, elem(input_tuple, n_index), n_index)
          operation_runner(target_value, input_tuple, tl(remaining_operations)++options)
        else
          operation_runner(target_value, input_tuple, tl(remaining_operations))
        end
      end
    end
  end

  def operation_runner(target_value, input_tuple) do
    operation_runner(target_value, input_tuple, build_options(elem(input_tuple,0), elem(input_tuple,1), 1))
  end

  def string_to_computation(str) do
    comps = parse_line_to_components(str)
    left_side = Utils.to_int(hd(comps))
    right_side = parse_string_components(hd(tl(comps)))
    if operation_runner(left_side, right_side) do
      left_side
    else
      0
    end
  end

  def convert_input_str_to_list(str) do
    String.split(str, "\n", trim: true)
  end

  def count_successful_operations(str) do
    Enum.reduce(
      convert_input_str_to_list(str), 0, fn line, acc -> acc+string_to_computation(line) end)
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    count_successful_operations(content)
  end
  def part2(filename) do
    IO.puts("NOT YET IMPLEMENTED")
  end

end
