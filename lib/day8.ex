defmodule Day8 do
  @doc """
  Creates a sum between two, tuples where elem x in both tuples is summed.
  """
  def tuple_sum(t1, t2) do
    List.to_tuple(
      Enum.reduce(0..(tuple_size(t1) - 1), [], fn x, acc -> acc ++ [elem(t1, x) + elem(t2, x)] end)
    )
  end

  def negate_tuple(tup) do
    List.to_tuple(Enum.map(Tuple.to_list(tup), fn x -> x * -1 end))
  end

  @doc """
  Gets the slope between two points defined by a tuple {x_difference, y_difference}
  """
  def get_slope(pt1, pt2) do
    tuple_sum(pt2, negate_tuple(pt1))
  end

  def get_next_point(pt, slope_tuple, direction) do
    case direction do
      x when x == :next -> tuple_sum(pt, slope_tuple)
      x when x == :previous -> tuple_sum(pt, negate_tuple(slope_tuple))
    end
  end

  def one_pt_in_direction(pt, slope, direction, x_size, y_size) do
    next_point = get_next_point(pt, slope, direction)

    if Utils.check_on_map(elem(next_point, 0), elem(next_point, 1), x_size, y_size) == true do
      next_point
    else
      nil
    end
  end

  def get_points_in_direction_on_board(pt, slope, direction, x_size, y_size) do
    Enum.reduce_while(0..(x_size * y_size), [pt], fn _, acc ->
      next_point = get_next_point(List.last(acc), slope, direction)

      if Utils.check_on_map(elem(next_point, 0), elem(next_point, 1), x_size, y_size) == true do
        {:cont, acc ++ [next_point]}
      else
        {:halt, acc}
      end
    end)
  end

  def get_points_both_directions(pt1, pt2, x_size, y_size) do
    slope = get_slope(pt1, pt2)
    next = get_points_in_direction_on_board(pt2, slope, :next, x_size, y_size)
    previous = get_points_in_direction_on_board(pt1, slope, :previous, x_size, y_size)
    tl(next) ++ tl(previous)
  end

  def get_point_on_each_size(pt1, pt2, x_size, y_size) do
    slope = get_slope(pt1, pt2)
    next = one_pt_in_direction(pt2, slope, :next, x_size, y_size)
    previous = one_pt_in_direction(pt1, slope, :previous, x_size, y_size)

    Enum.reduce([[next], [previous]], [], fn x, acc ->
      if x do
        if x != next and x != previous do
          acc ++ x
        else
          acc
        end
      else
        acc
      end
    end)
  end

  def generate_map_from_split_str(str) do
    Enum.reduce(
      Enum.with_index(String.split(str, "\n", trim: true)),
      %{},
      fn line, acc ->
        Enum.reduce(
          Enum.with_index(String.split(elem(line, 0), "", trim: true)),
          acc,
          fn element, acc ->
            elem_val = elem(element, 0)

            case elem_val do
              x when x == "." ->
                acc

              _ ->
                Map.put(
                  acc,
                  elem(element, 0),
                  Map.get(acc, elem(element, 0), []) ++ [{elem(line, 1), elem(element, 1)}]
                )
            end
          end
        )
      end
    )
  end

  def get_unique_all_pts(pts_list) do
    Enum.count(Enum.uniq(pts_list))
  end

  @spec self_mix_pairings(list()) :: any()
  def self_mix_pairings(list_tups) do
    tupl_w_elems = Enum.with_index(list_tups)
    tuple_tuple = List.to_tuple(tupl_w_elems)

    Enum.reduce(0..(length(tupl_w_elems) - 2), [], fn x, acc ->
      Enum.reduce(
        (elem(elem(tuple_tuple, x), 1) + 1)..(length(tupl_w_elems) - 1),
        acc,
        fn y, acc ->
          first = elem(elem(tuple_tuple, x), 0)
          second = elem(elem(tuple_tuple, y), 0)
          acc ++ [[first, second]]
        end
      )
    end)
  end

  def find_points_for_key(map, key) do
    self_mix_pairings(Map.get(map, key))
  end

  def get_points_for_all_keys(map, size_x, size_y, type) do
    Enum.reduce(Map.keys(map), [], fn key, acc ->
      Enum.reduce(find_points_for_key(map, key), acc, fn pt_pair, acc ->
        pt1 = List.first(pt_pair)
        pt2 = List.last(pt_pair)

        case type do
          x when x == :one -> acc ++ get_point_on_each_size(pt1, pt2, size_x, size_y)
          x when x == :all -> acc ++ get_points_both_directions(pt1, pt2, size_x, size_y)
        end
      end)
    end)
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    map = generate_map_from_split_str(content)
    split_n = String.split(content, "\n", trim: true)
    x_length = length(split_n)
    y_length = String.length(hd(split_n))
    all_pts = get_unique_all_pts(get_points_for_all_keys(map, x_length, y_length, :one))
    all_pts
  end

  def part2(filename) do
    {:ok, content} = File.read(filename)
    map = generate_map_from_split_str(content)
    split_n = String.split(content, "\n", trim: true)
    x_length = length(split_n)
    y_length = String.length(hd(split_n))
    all_pts = get_unique_all_pts(get_points_for_all_keys(map, x_length, y_length, :all))
    all_pts
  end
end
