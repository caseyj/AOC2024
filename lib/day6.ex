defmodule Day6  do

def is_block(row, column, matrix) do
  spot_value = elem(elem(matrix, row), column)
  determine_object(spot_value) == :block
end

def rotate_guard(current_direction) do
  case current_direction do
    x when  x==:north -> :east
    x when  x==:east-> :south
    x when  x==:south -> :west
    x when  x==:west -> :north
  end
end

def check_on_map(row, column, size_x, size_y) do
  if (row >= 0 and row<size_x) and (column >= 0 and column<size_y) do
    true
  else
    false
  end
end

def parse_raw(str) do
  List.to_tuple(Enum.map(String.split(str, "\n", trim: true), fn x -> List.to_tuple(String.split(x, "", trim: true)) end))
end

def detect_guard_position(matrix) do
  Enum.reduce(Enum.with_index(Tuple.to_list(matrix)), {}, fn row, acc ->
    indx = Enum.find_index(Tuple.to_list(elem(row,0)), fn x -> x== "^" end)
    if indx do
      {elem(row, 1), indx, :north}
    else
      acc
    end
  end)
end

def guard_turn(row, column, matrix, current_direction, size_x, size_y,guard_positions) do
  new_spot = Utils.direction_operator(row, column, current_direction, 1)
  if check_on_map(elem(new_spot, 0), elem(new_spot, 1),size_x, size_y) ==false do
    guard_positions
  else
    if is_block(elem(new_spot, 0), elem(new_spot, 1), matrix) do
      guard_turn(row, column, matrix, rotate_guard(current_direction), size_x, size_y,guard_positions)
    else
      if Enum.member?(guard_positions, new_spot) == false do
        guard_turn(elem(new_spot, 0), elem(new_spot, 1), matrix, current_direction,size_x, size_y, guard_positions++[new_spot])
      else
        guard_turn(elem(new_spot, 0), elem(new_spot, 1), matrix, current_direction, size_x, size_y, guard_positions)
      end
    end
  end
end

@doc """
During puzzle input parse, this function determines what the object in each parse is
"""
def determine_object(value) do
  case value do
    x when x == "#" -> :block
    x when x == "^" -> :guard
    x when x == "." -> :ignore
  end
end

def part1(filename) do
  {:ok, content} = File.read(filename)
  matrix = parse_raw(content)
  guard = detect_guard_position(matrix)
  matrix_length = tuple_size(matrix)
  matrix_width = tuple_size(elem(matrix, 0))
  Enum.count(guard_turn(
    elem(guard, 0),
    elem(guard, 1),
    matrix,
    elem(guard, 2),
    matrix_length,
    matrix_width,
    [])) # off by 1 in actual answer, not sure on reason
end
def part2(filename) do
  {:ok, _} = File.read(filename)
  IO.puts("NOT YET IMPLEMENTED")
  #all_x_s(input_to_map(parse_input(contents)))
end

end
