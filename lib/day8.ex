defmodule Day8 do

  @doc """
  Creates a sum between two, tuples where elem x in both tuples is summed.
  """
  def tuple_sum(t1, t2) do
    List.to_tuple(Enum.reduce(0..tuple_size(t1)-1, [], fn x, acc -> acc++[elem(t1, x)+elem(t2, x)] end))
  end

  def negate_tuple(tup) do
    List.to_tuple(Enum.map(Tuple.to_list(tup), fn x -> x*-1 end))
  end

  @doc """
  Gets the slope between two points defined by a tuple {x_difference, y_difference}
  """
  def get_slope(pt1, pt2) do
    tuple_sum(pt2, negate_tuple(pt1))
  end

  def get_next_point(pt, slope_tuple, direction) do
    case direction do
      x when x==:next -> tuple_sum(pt, slope_tuple)
      x when x==:previous -> tuple_sum(pt, negate_tuple(slope_tuple))
    end
  end

  def get_points_in_direction_on_board(pt, slope, direction, x_size, y_size) do
    Enum.reduce_while(0..x_size*y_size, [pt], fn _, acc ->
      next_point = get_next_point(List.last(acc), slope, direction)
      if Utils.check_on_map(elem(next_point, 0), elem(next_point, 1), x_size, y_size) == true do
        {:cont, acc++[next_point]}
      else
        {:halt, acc}
      end
    end)
  end

end