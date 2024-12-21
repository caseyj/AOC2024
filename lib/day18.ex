defmodule Day18 do

  def heuristic(object_a, object_b) do
    a_score = elem(object_a, 2) + elem(object_a, 3)
    b_score = elem(object_b, 2) + elem(object_b, 3)
    a_score < b_score
  end

  def a_star(queue, target, seen,walls) do
    {{x, y}, direction, score, distance, history} = hd(queue)
    if {x, y}==target do
      {{x, y}, direction, score, distance, history}
    else
      queue_point_list = Enum.reduce(queue, [], fn  q, acc-> acc++[elem(q, 0)] end)
      points = Enum.map([:north, :south, :east, :west], fn next_direction ->
        {y,x} = Utils.direction_operator(y, x,next_direction,1)
        {{x,y}, next_direction}
      end)
      |>Utils.filter_elements_from_multiple_lists([queue_point_list, seen, walls])
      |>Enum.filter(fn {{column, row}, _} ->
        Utils.check_on_map(row, column, elem(target, 0)+1, elem(target, 1)+1) == true
      end)
      |>Enum.map(fn {point, new_direction} ->
        {point, new_direction, score+1, Utils.manhattan(point, target), history++[{x,y}]}
      end)
      new_queue = Enum.sort(tl(queue)++points, &(heuristic(&1, &2)))
      a_star(new_queue, target, seen++[{x,y}], walls)
    end
  end

  def a_star_for_size_restricted_input(str_input, size, start_pos, end_pos) do
    intake = intake_str(str_input, size)
    initial_start = {
      start_pos,
      :north,
      0,
      Utils.manhattan(start_pos, end_pos),
      []
    }
    try do
      {:ok, a_star([initial_start], end_pos, [], intake)}
    rescue
      _ ->{:fail, {}}
    end
  end

  def find_next_half(previous, previous_result, last_success,size) do
    case previous_result do
      x when x== :ok -> List.to_tuple(Enum.to_list(previous+1..size-1))
      x when x== :fail ->List.to_tuple(Enum.to_list(last_success..previous-1))
    end
  end

  def find_next_end_pos(indices) do
    elem(indices, floor(div(tuple_size(indices),2)))
  end

  def search_for_last_viable_elem(str_input, previous, previous_result, last_success,start_pos, end_pos) do
    split_str = _str_split(str_input)
    size = length(split_str)
    indices = find_next_half(previous, previous_result, last_success,size)
    if tuple_size(indices) == 1 do
      elem(List.pop_at(split_str,previous-1), 0)
    else
      next_prev = find_next_end_pos(indices)
      {result, _} = a_star_for_size_restricted_input(str_input, next_prev, start_pos, end_pos)
      if result == :ok do

        search_for_last_viable_elem(str_input, next_prev, result, next_prev,start_pos, end_pos)
      else

        search_for_last_viable_elem(str_input, next_prev, result, last_success,start_pos, end_pos)
      end
    end
  end

  def _str_split(str) do
    String.split(str, "\n", trim: true)
  end

  def intake_str(str, size) do
    Enum.map(Enum.take(_str_split(str), size), fn line ->
      List.to_tuple(Enum.map(String.split(line, ",", trim: true), fn elm -> Utils.to_int(elm) end))
    end)
  end

  @spec part1(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) :: {:ok, binary()}
  def part1(filename) do
    {:ok, content} = File.read(filename)
    target = {70,70}
    start = {0,0}
    initial_start = {
      start,
      :north,
      0,
      Utils.manhattan(start, target),
      []
    }
    elem(a_star([initial_start], target, [], intake_str(content, 1024)), 2)
  end

  def part2(filename) do
    {:ok, content} = File.read(filename)
    search_for_last_viable_elem(content, 0, :ok, 0, {0,0}, {70,70})
  end


end
