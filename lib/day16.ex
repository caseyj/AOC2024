defmodule Day16 do
  def score_move(new_point, previous_point, _) do
    if elem(new_point, 1) == elem(previous_point,1) do
      elem(previous_point,2)+1
    else
      elem(previous_point,2)+1001
    end

  end



  def distance(current_point, target) do
    :math.sqrt(
      Enum.reduce(Enum.zip(Tuple.to_list(current_point), Tuple.to_list(target)), 0, fn {x1, x2},acc ->
        acc + :math.pow(x2 - x1, 2)
      end)
    )
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    parse_map = Utils.generate_map_from_split_str(content)
    {start_x, start_y} = hd(Map.get(parse_map, "S"))
    {targ_x,targ_y} = hd(Map.get(parse_map, "E"))
    result =
      Utils.a_star_w_direction_options_function(
        [{{start_y, start_x}, :east, 0, Utils.manhattan({start_y, start_x}, {targ_y,targ_x}),[]}],
        {targ_y,targ_x},
        [],
        Map.get(parse_map, "#"),
        &score_move/3,
        14,14,
        []
      )

    elem(result, 2)
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)
    IO.puts("NOT YET IMPLEMENTED")
  end
end
