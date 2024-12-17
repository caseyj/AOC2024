defmodule Day16 do

  def score_move(direction, previous_direction) do
    case direction do
      x when x == previous_direction -> 1
      _ -> 1001
    end
  end

  def get_options(direction) do
    case direction do
      x when x == :north -> [:north, :east, :west]
      x when x == :south -> [:south, :east, :west]
      x when x == :east -> [:north, :east, :south]
      x when x == :west -> [:south, :north, :west]
      x when x == :nil -> [:south, :north, :west, :east]
    end
  end

  def distance(current_point, target) do
    :math.sqrt(Enum.reduce(Enum.zip(Tuple.to_list(current_point), Tuple.to_list(target)), 0, fn {x1,x2}, acc ->
      acc+:math.pow((x2-x1), 2)
    end))
  end

  def manhattan(current_point, target) do
    Enum.reduce(Enum.zip(Tuple.to_list(current_point), Tuple.to_list(target)), 0, fn {x1,x2}, acc -> acc+abs(x2-x1) end)
  end

  def filter_elements_from_multiple_lists(points, lists) do
    Enum.reduce(lists, points, fn list, acc ->
      Enum.filter(acc, fn point -> Enum.member?(list, elem(point,0))==false end)
    end)

  end


  def a_star(queue, target, seen,walls) do
    {{x, y}, direction, current_score, distance} = hd(queue)
    if {x, y}==target do
      {{x, y}, direction, current_score, distance}
    else
      queue_point_list = Enum.reduce(queue, [], fn  q, acc-> acc++[elem(q, 0)] end)
      points = Enum.map(get_options(direction), fn next_direction ->
        {Utils.direction_operator(x, y,next_direction,1), next_direction}
      end)
      |>filter_elements_from_multiple_lists([queue_point_list, seen, walls])
      |>Enum.map(fn {point, new_direction} ->
        score = score_move(new_direction, direction)+current_score
        {point, new_direction, score , score+manhattan(point, target)}
      end)
      new_queue = Enum.sort(tl(queue)++points, &(elem(&1, 3)<elem(&2, 3)))
      a_star(new_queue, target, seen++[{x,y}], walls)
    end
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    parse_map = Utils.generate_map_from_split_str(content)
    result = a_star([{hd(Map.get(parse_map, "S")), :east, 0, 1000000}], hd(Map.get(parse_map, "E")), [], Map.get(parse_map, "#"))
    elem(result,2)
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)
    IO.puts("NOT YET IMPLEMENTED")
  end

end
