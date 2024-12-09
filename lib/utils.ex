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
end
