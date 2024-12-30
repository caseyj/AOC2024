defmodule Day16 do


  def score_move(new_point, previous_point, _) do
    if elem(new_point, 1) == elem(previous_point,1) do
      elem(previous_point,2)-Utils.manhattan(elem(new_point, 0), elem(previous_point, 0))+1
    else
      elem(previous_point,2)- Utils.manhattan(elem(new_point, 0), elem(previous_point, 0))+1001
    end
  end

  def djikstra_score_move(previous, option, prior_score) do
    if previous == option do
      prior_score+1
    else
      prior_score+1000
    end
  end

  def calc_total_score(history) do
    Enum.reduce(history, {0, :east}, fn elm, acc ->
      current = elem(elm, 1)
      previous = elem(acc, 1)
      if current == previous do
        {elem(acc, 0)+1, current}
      else
        {elem(acc, 0)+1001, current}
      end
    end)
  end

  def in_list_a_not_in_list_b(point, list_a, list_b) do
    is_member = Enum.member?(list_a, point) == true
    not_member = Enum.member?(list_b, point)==false
    is_member == true and not_member == true
  end

  @doc """
  Gets the size of a grid that is a count of how many \n characters appear and how many characters appear between each \n
  """
  def get_size(str) do
    lines = String.split(str, "\n", trim: true)
    {String.length(hd(lines)), length(lines)}
  end

  def score_comp(element_a, element_b) do
    elem(element_a, 3) < elem(element_b, 3)
  end

  def get_index_from_list(point, list) do
    Enum.find_index(list, fn elm -> elem(elm, 0) == point end)
  end

  def correct_list_with_new_elements(points, list) do
    Enum.reduce(points, list, fn point, acc ->
      indx = get_index_from_list(elem(point,0), acc)
      if indx != nil do
        if elem(point,3) < elem(Enum.fetch!(acc, indx), 3) do
          List.replace_at(acc, indx, point)
        else
          acc
        end
      else
        acc ++ [point]
      end
    end)
  end

  def djikstra(queue, collected, graph_points) do
    if length(queue) == 0 do
      collected
    else
      existing_list = Enum.map(collected, fn col -> elem(col, 0) end)
      {{x, y}, direction, _, score} = hd(queue)
      filtered = Enum.reduce(Utils.get_options(direction), [], fn option, acc ->
        if direction ==  option do
          {ny, nx} = Utils.direction_operator(y, x, option, 1)
          acc ++ [ {{nx, ny}, option, {x,y}, djikstra_score_move(direction,option,score)} ]
        else
          acc ++ [ {{x,y}, option, {x,y}, djikstra_score_move(direction,option,score)} ]
        end
      end)
      |> Enum.filter(fn elm -> Enum.member?(graph_points, elem(elm, 0)) end)
      rejected = Enum.reject(filtered , fn elm -> Enum.member?(existing_list, elem(elm, 0))  end)
      corrected_queue = correct_list_with_new_elements(rejected, tl(queue))
      sorted = Enum.sort(corrected_queue, &score_comp(&1, &2))
      djikstra(sorted, collected++[hd(queue)], graph_points)
    end
  end

  def djikstra(start_point, graph_points) do
    start = {start_point, :east, start_point, 0}
    djikstra([start], [], graph_points)
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    parse_map = Utils.generate_map_from_split_str(content)
    {start_x, start_y} = hd(Map.get(parse_map, "S"))
    {targ_x,targ_y} = hd(Map.get(parse_map, "E"))
    map_start_end_added = Utils.map_append_lists(parse_map,".", [{start_x, start_y},{targ_x,targ_y}])
    start_distance = Utils.manhattan({start_x, start_y}, {targ_x,targ_y})
    {size_x, size_y} = get_size(content)
    """
    result =
      Utils.a_star_w_direction_options_function(
        [{{start_x, start_y}, :east, 0, start_distance,[]}],
        {targ_x,targ_y},
        [],
        Map.get(parse_map, "#"),
        &score_move/3,
        size_x,size_y,
        []
      )
      score= calc_total_score(elem(result, 4))
      elem(score,0)-1
    """
    result = djikstra({start_x, start_y}, Map.get(map_start_end_added, "."))
    filtered = Enum.filter(result, fn elm -> elem(elm, 0) == {targ_x, targ_y} end)
    elem(hd(filtered), 3)
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)
    IO.puts("NOT YET IMPLEMENTED")
  end
end
