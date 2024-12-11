defmodule Day10 do


  @doc """
  Checks the next step taken is not the previous spot on the map
  """
  def not_previous_steps(row, column, previous_row, previous_column) do
    {row,column} != {previous_row, previous_column}
  end

  @spec next_spot_climbable(
          tuple(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer()
        ) :: boolean()
  def next_spot_climbable(matrix,row, column, current_row, current_column) do
    next_val = Utils.get_value_from_2d_tuple(matrix, row, column)
    current_val = Utils.get_value_from_2d_tuple(matrix, current_row, current_column)
    next_val - current_val == 1
  end

  @spec check_step_for_validity(
    tuple(),
    non_neg_integer(),
    non_neg_integer(),
    non_neg_integer(),
    non_neg_integer(),
    non_neg_integer(),
    non_neg_integer()
    ) :: boolean()
  @doc """
  Generates a list of positions to take that are valid next steps
  """
  def check_step_for_validity(matrix,row, column, current_row, current_column, previous_row, previous_column) do
    not_previous_steps(row, column, previous_row, previous_column) == true and next_spot_climbable(matrix,row, column, current_row, current_column)
  end

  def get_only_valid_unseen(matrix, next_steps, current_pair , seen,scheduled_list) do
    Enum.filter(get_only_valid_unseen(matrix, next_steps, current_pair , seen), fn x -> Enum.member?(scheduled_list, x) == false end)

  end

  def get_only_valid_unseen(matrix, next_steps, current_pair , seen) do
    Enum.filter(
        Enum.filter(next_steps, fn x ->
          Utils.check_on_map(
            elem(x,0),
            elem(x,1),
            tuple_size(matrix),
            tuple_size(elem(matrix,0))) == true
        end),
        fn x ->
        next_spot_climbable(
          matrix,
          elem(x, 0),
          elem(x, 1),
          elem(current_pair, 0),
          elem(current_pair, 1)
        )
        and
        (Enum.member?(seen, x) == false)
      end)
  end

  def conduct_path(start_row, start_column, matrix) do
    Enum.reduce_while(0..(tuple_size(matrix)*tuple_size(elem(matrix,0))), %{:paths_counter=>0, :seen=>[],:scheduled=>[{start_row, start_column}]}, fn _, acc ->
      if Map.get(acc, :scheduled) == [] do
        {:halt, acc}
      else
        current_pair = hd(Map.get(acc, :scheduled))
        seen_updated = Map.put(acc, :seen, Map.get(acc, :seen)++[current_pair])
        schedule_updated = Map.put(seen_updated, :scheduled, tl(Map.get(seen_updated, :scheduled)))
        if Utils.get_value_from_2d_tuple(matrix, elem(current_pair,0), elem(current_pair,1)) == 9 do
          #future_traversals_removed = Map.put(schedule_updated, :scheduled, Enum.reject(Map.get(schedule_updated, :scheduled), fn x -> x != current_pair end))
          {:cont, Map.put(schedule_updated, :paths_counter, Map.get(schedule_updated, :paths_counter)+1)}
        else
          next_steps = Utils.get_pot_next_steps(elem(current_pair, 0), elem(current_pair, 1), [:north, :south, :east, :west], 1)
          filtered_steps = get_only_valid_unseen(matrix, next_steps, current_pair, Map.get(acc, :seen),Map.get(acc, :scheduled))
          {:cont,Map.put(schedule_updated, :scheduled, filtered_steps++Map.get(schedule_updated, :scheduled))}
        end

      end
    end)
  end

  def find_value_coords(matrix, target_value) do
    Enum.reduce(0..tuple_size(matrix)-1, [], fn x, acc ->
      acc++Enum.reduce(0..tuple_size(elem(matrix, x))-1, [], fn y,acc2 ->
        coord_value = Utils.get_value_from_2d_tuple(matrix, x, y)
        if coord_value == target_value do
          acc2++[{x,y}]
        else
          acc2
        end
      end)
    end)
  end

  def find_all_roads(matrix, target_value) do
    Enum.reduce(find_value_coords(matrix, target_value), 0, fn x, acc ->
      path_conduct = conduct_path(elem(x,0),elem(x,1),matrix)
      acc+Map.get(path_conduct,:paths_counter)
    end)
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    matrix = Utils.parse_string_to_two_tuple(content, &Utils.to_int/1)
    find_all_roads(matrix, 0)
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)
    IO.puts("NOT YET IMPLEMENTED")
  end

end
