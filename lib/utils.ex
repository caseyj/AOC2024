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
end
