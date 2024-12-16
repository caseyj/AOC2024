defmodule Day14 do

  def find_spot_for_direction(start_position, slope, turns, size) do
    move_amount = slope*turns
    position_delta = move_amount + start_position
    position_post_grid = rem(position_delta, size)
    if position_post_grid < 0 do
      size + position_post_grid
    else
      position_post_grid
    end
  end

  def find_spot_after_n_turns(
    starting_position,
    slope,
    turns,
    size_x,
    size_y) do
      {
        find_spot_for_direction(
          elem(starting_position, 0),
          elem(slope,0),
          turns,
          size_x),
        find_spot_for_direction(
          elem(starting_position, 1),
          elem(slope,1),
          turns,
          size_y
        )
      }
  end

  def parse_position_and_slope(str) do
    captured = Regex.named_captures(~r/p=(?<position_x>[-]?\d+),(?<position_y>[-]?\d+)\Wv=(?<slope_x>[-]?\d+),(?<slope_y>[-]?\d+)/, str)
    {
      {
        Utils.to_int(Map.get(captured,"position_x")),
        Utils.to_int(Map.get(captured,"position_y"))
      },
      {
        Utils.to_int(Map.get(captured,"slope_x")),
        Utils.to_int(Map.get(captured,"slope_y"))
      }
    }
  end

  def get_quadrant_locations(size_x, size_y) do
    {floor(div(size_x, 2)), floor(div(size_y, 2))}
  end

  def get_point_quadrant(point, size_x, size_y) do
    {quads_x,quads_y} = get_quadrant_locations(size_x, size_y)
    {x,y} = point
    cond do
      x<quads_x and y<quads_y -> :first
      x>quads_x and y<quads_y -> :fourth
      x>quads_x and y>quads_y -> :third
      x<quads_x and y>quads_y -> :second
      x-> :remove
    end
  end

  def str_to_point_slopes(str) do
    Enum.reduce(
      String.split(str, "\n", trim: true),
      [],
      fn line, acc ->
        acc++[parse_position_and_slope(line)]
      end)
  end

  def count_quadrants(str,turns, size_x, size_y) do

    points = Enum.reduce(str_to_point_slopes(str), [], fn pt_slope, acc ->
      new_spot = find_spot_after_n_turns(elem(pt_slope, 0),elem(pt_slope, 1),turns,size_x,size_y)
      acc++[new_spot]
    end)
    Enum.reduce(points, %{}, fn point, acc ->
      key = get_point_quadrant(point, size_x, size_y)
      Map.put(acc, key, Map.get(acc, key, 0) +1)
    end)
  end

  def mult_quadrants(quad_map) do
    Enum.reduce([:first, :second, :third, :fourth], 1, fn atm, acc ->
      acc*Map.get(quad_map, atm)
    end)
  end

  def variance(var_list) do
    mean = div(Enum.sum(var_list), length(var_list))
    div(Enum.reduce(var_list, 0,fn var,acc ->
      acc+:math.pow((var-mean),2)
    end), length(var_list))
  end


  def get_variances(points) do
    x_var = variance(Enum.reduce(points, [], fn point, acc -> acc++[elem(point, 0)] end))
    y_var = variance(Enum.reduce(points, [], fn point, acc -> acc++[elem(point, 1)] end))
    {x_var, y_var}
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    mult_quadrants(count_quadrants(content, 100, 101,103))
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)

  end

end
