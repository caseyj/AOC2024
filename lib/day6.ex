defmodule Day6 do
  def is_block(row, column, matrix) do
    spot_value = elem(elem(matrix, row), column)
    determine_object(spot_value) == :block
  end

  def rotate_guard(current_direction) do
    case current_direction do
      x when x == :north -> :east
      x when x == :east -> :south
      x when x == :south -> :west
      x when x == :west -> :north
    end
  end

  def previous_rotation(current_direction, remaining) do
    if remaining == 0 do
      current_direction
    else
      previous_rotation(rotate_guard(current_direction), remaining - 1)
    end
  end

  def previous_rotation(current_direction) do
    previous_rotation(current_direction, 3)
  end

  def opposite_rotation(current_direction) do
    previous_rotation(current_direction, 2)
  end

  def check_on_map(row, column, size_x, size_y) do
    if row >= 0 and row < size_x and (column >= 0 and column < size_y) do
      true
    else
      false
    end
  end

  def parse_raw(str) do
    List.to_tuple(
      Enum.map(String.split(str, "\n", trim: true), fn x ->
        List.to_tuple(String.split(x, "", trim: true))
      end)
    )
  end

  def detect_guard_position(matrix) do
    Enum.reduce(Enum.with_index(Tuple.to_list(matrix)), {}, fn row, acc ->
      indx = Enum.find_index(Tuple.to_list(elem(row, 0)), fn x -> x == "^" end)

      if indx do
        {elem(row, 1), indx, :north}
      else
        acc
      end
    end)
  end

  def guard_turn(row, column, matrix, current_direction, size_x, size_y, guard_positions) do
    new_spot = Utils.direction_operator(row, column, current_direction, 1)

    if check_on_map(elem(new_spot, 0), elem(new_spot, 1), size_x, size_y) == false do
      guard_positions
    else
      if is_block(elem(new_spot, 0), elem(new_spot, 1), matrix) do
        guard_turn(
          row,
          column,
          matrix,
          rotate_guard(current_direction),
          size_x,
          size_y,
          guard_positions
        )
      else
        if Enum.member?(guard_positions, new_spot) == false do
          guard_turn(
            elem(new_spot, 0),
            elem(new_spot, 1),
            matrix,
            current_direction,
            size_x,
            size_y,
            guard_positions ++ [new_spot]
          )
        else
          guard_turn(
            elem(new_spot, 0),
            elem(new_spot, 1),
            matrix,
            current_direction,
            size_x,
            size_y,
            guard_positions
          )
        end
      end
    end
  end

  def guard_turn_w_direction(
        row,
        column,
        matrix,
        current_direction,
        size_x,
        size_y,
        guard_positions
      ) do
    new_spot = Utils.direction_operator(row, column, current_direction, 1)

    if check_on_map(elem(new_spot, 0), elem(new_spot, 1), size_x, size_y) == false do
      guard_positions
    else
      if is_block(elem(new_spot, 0), elem(new_spot, 1), matrix) do
        guard_turn_w_direction(
          row,
          column,
          matrix,
          rotate_guard(current_direction),
          size_x,
          size_y,
          guard_positions ++ [{row, column, rotate_guard(current_direction)}]
        )
      else
        if Enum.member?(guard_positions, new_spot) == false do
          guard_turn_w_direction(
            elem(new_spot, 0),
            elem(new_spot, 1),
            matrix,
            current_direction,
            size_x,
            size_y,
            guard_positions ++ [{elem(new_spot, 0), elem(new_spot, 1), current_direction}]
          )
        else
          guard_turn_w_direction(
            elem(new_spot, 0),
            elem(new_spot, 1),
            matrix,
            current_direction,
            size_x,
            size_y,
            guard_positions
          )
        end
      end
    end
  end

  def range_to_max(dynamic_number, mxn) do
    Enum.to_list(dynamic_number..mxn)
  end

  def dynamic_static_numbers_to_list(dynamic, static, vert_horizontal) do
    case vert_horizontal do
      x when x == :vertical -> Enum.map(dynamic, fn y -> {y, static} end)
      x when x == :horizontal -> Enum.map(dynamic, fn y -> {static, y} end)
    end
  end

  @spec get_next_directions(any(), any(), :east | :north | :south | :west, tuple()) :: list()
  def get_next_directions(row, column, direction, matrix) do
    row_length = tuple_size(matrix)
    column_length = tuple_size(elem(matrix, 0))

    case direction do
      x when x == :north ->
        dynamic_static_numbers_to_list(range_to_max(row - 1, 0), column, :vertical)

      x when x == :east ->
        dynamic_static_numbers_to_list(range_to_max(column + 1, column_length), row, :horizontal)

      x when x == :south ->
        dynamic_static_numbers_to_list(range_to_max(row + 1, row_length - 1), column, :vertical)

      x when x == :west ->
        dynamic_static_numbers_to_list(range_to_max(column - 1, 0), row, :horizontal)
    end
  end

  def detect_block_causing_turns(position_list) do
    positions = Enum.with_index(position_list)
    positions_by_tuple = List.to_tuple(positions)

    Enum.reduce(positions, [], fn position, acc ->
      current_index = elem(position, 1)

      if current_index > 0 do
        previous = elem(elem(positions_by_tuple, current_index - 1), 0)
        current_direction = elem(elem(position, 0), 2)
        previous_direction = elem(previous, 2)

        if current_direction != previous_direction do
          acc ++ [previous]
        else
          acc
        end
      else
        []
      end
    end)
  end

  def find_block(list_coords, matrix) do
    Enum.find_value(list_coords, fn x ->
      row_coord = elem(x, 0)
      column_coord = elem(x, 1)

      if elem(elem(matrix, row_coord), column_coord) == "#" do
        x
      end
    end)
  end

  def find_span(list_coords, matrix) do
    block = find_block(list_coords, matrix)

    if block do
      Enum.take_while(list_coords, fn x -> x != block end)
    else
      list_coords
    end
  end

  def count_injectable_objects(matrix, found_path) do
    Enum.count(
      Enum.reduce(detect_block_causing_turns(found_path), [], fn x, acc ->
        acc ++
          Enum.reduce(
            obstacle_inject_for_change(elem(x, 0), elem(x, 1), elem(x, 2), matrix, found_path),
            [],
            fn y, acc2 ->
              if Enum.member?(acc, y) == false do
                acc2 ++ [y]
              else
                acc2
              end
            end
          )
      end)
    )
  end

  def obstacle_inject_for_change(row, column, direction, matrix, found_path) do
    next_directions =
      get_next_directions(
        row,
        column,
        opposite_rotation(direction),
        matrix
      )

    next_spots =
      Enum.reduce(next_directions, [], fn x, acc ->
        acc ++ [{elem(x, 0), elem(x, 1), previous_rotation(direction)}]
      end)

    repeats =
      Enum.reduce(next_spots, [], fn x, acc ->
        if Enum.member?(found_path, x) do
          acc ++ [x]
        else
          acc
        end
      end)

    Enum.map(repeats, fn x -> Utils.direction_operator(elem(x, 0), elem(x, 1), elem(x, 2), 1) end)
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

  def get_path_from_matrix(matrix) do
    guard = detect_guard_position(matrix)
    matrix_length = tuple_size(matrix)
    matrix_width = tuple_size(elem(matrix, 0))

    guard_turn(
      elem(guard, 0),
      elem(guard, 1),
      matrix,
      elem(guard, 2),
      matrix_length,
      matrix_width,
      []
    )
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    matrix = parse_raw(content)
    # off by 1 in actual answer, not sure on reason
    Enum.count(get_path_from_matrix(matrix))
  end

  def part2(filename) do
    {:ok, content} = File.read(filename)
    matrix = parse_raw(content)
    guard = detect_guard_position(matrix)
    matrix_length = tuple_size(matrix)
    matrix_width = tuple_size(elem(matrix, 0))

    gt =
      guard_turn_w_direction(
        elem(guard, 0),
        elem(guard, 1),
        matrix,
        elem(guard, 2),
        matrix_length,
        matrix_width,
        []
      )

    count_injectable_objects(matrix, gt)
  end
end
