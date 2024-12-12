defmodule Utils do

  @spec to_int(binary()) :: integer()
  def to_int(int) do
    String.to_integer(int)
  end

  @doc """
  Gets the next position from a starting coordinate, direction, and number of spaces.
  """
  @spec direction_operator(any(), any(), any(), any()) :: {integer(), integer()}
  def direction_operator(start_row, start_column, direction, distance) do
    if distance == 0 do
      {start_row, start_column}
    else
      case direction do
        x when x == :north -> direction_operator(start_row-1, start_column, direction, distance-1)
        x when x == :south -> direction_operator(start_row+1, start_column, direction, distance-1)
        x when x == :east -> direction_operator(start_row, start_column+1, direction, distance-1)
        x when x == :west -> direction_operator(start_row, start_column-1, direction, distance-1)
        x when x == :northeast -> direction_operator(start_row-1, start_column+1, direction, distance-1)
        x when x == :northwest -> direction_operator(start_row-1, start_column-1, direction, distance-1)
        x when x == :southeast -> direction_operator(start_row+1, start_column+1, direction, distance-1)
        x when x == :southwest -> direction_operator(start_row+1, start_column-1, direction, distance-1)
      end
    end
  end

  def check_on_map(row, column, size_x, size_y) do
    if (row >= 0 and row<size_x) and (column >= 0 and column<size_y) do
      true
    else
      false
    end
  end

  @spec map_append_lists(map(), any(), any()) :: map()
  @doc"""
  function automates adding elements to a map between arbitrary keys and lists at that key.

  Assumes the default value for any key of a map is an empty list
  """
  def map_append_lists(map, key, list) do
    Map.put(map, key, Map.get(map, key, [])++list)
  end


  @spec parse_string_to_two_tuple(binary()) :: tuple()
  @doc """
  Parses a string first by newlines, then by each element in each resuling string
  This function is exceptionally useful for building grid datastructures

  Example:
  "123\\n456" -> {{"1",2,3},{4,5,6}}
  """
  def parse_string_to_two_tuple(str) do
    List.to_tuple(Enum.map(String.split(str, "\n", trim: true), fn x -> List.to_tuple(String.split(x, "", trim: true)) end))
  end


  @doc """
  Parses a string first by newlines, then by each element in each resuling string
  This function is exceptionally useful for building grid datastructures

  Example:
  "123\\n456" -> {{1,2,3},{4,5,6}}
  """
  def parse_string_to_two_tuple(str, element_fn) do
    List.to_tuple(Enum.map(String.split(str, "\n", trim: true), fn x -> List.to_tuple(Enum.map(String.split(x, "", trim: true), fn x -> element_fn.(x) end)) end))
  end

  @spec get_pot_next_steps(integer(), integer(), :north | :northeast | :east | :southeast | :south | :southwest | :west | :northwest, integer()) :: tuple()
  @doc """
  From a list of directions and a distance, this function will return a list
  of the next two-tuple pairs of points with no filtering on validity
  """
  def get_pot_next_steps(row, column, directions, distance) do
    Enum.reduce(directions, [], fn x, acc ->
      acc++[Utils.direction_operator(row, column, x, distance)]
    end)
  end

  @spec get_value_from_2d_tuple(tuple(), non_neg_integer(), non_neg_integer()) :: any()
  @doc """
  Assists in retrieving values from 2d tuple matrices
  """
  def get_value_from_2d_tuple(matrix, row, column) do
    elem(elem(matrix, row), column)
  end

  def print_tuple(tup) do
    "{#{Enum.join(Tuple.to_list(tup), ",")}}"
  end

  def generate_map_from_split_str(str) do
    Enum.reduce(
      Enum.with_index(
        String.split(str, "\n", trim: true)
      ),
      %{},
      fn line, acc ->
        Enum.reduce(
          Enum.with_index(String.split(elem(line,0), "", trim: true)),
          acc,
          fn element, acc ->
            elem_val = elem(element,0)
            case elem_val do
              x when x=="."-> acc
              _ ->
                Map.put(acc, elem(element,0), Map.get(acc, elem(element,0), [])++[{elem(line,1),elem(element,1)}])
            end
          end
        )
      end
    )
  end

end
