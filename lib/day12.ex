defmodule Day12 do
  @spec get_letter_neighbors(integer(), integer(), list()) :: list()
  @doc """
  Function that gets the neighbors of a given coordinate pair that are members of a list
  """
  def get_letter_neighbors(letter_row, letter_column, letter_coords_list) do
    next_steps =
      Utils.get_pot_next_steps(
        letter_row,
        letter_column,
        [:north, :south, :east, :west],
        1
      )

    Enum.reduce(next_steps, [], fn x, acc ->
      if Enum.member?(letter_coords_list, x) do
        acc ++ [x]
      else
        acc
      end
    end)
  end

  @spec add_to_list_if_missing(any(), any()) :: any()
  @doc """
  Helper function that adds the members of a donor list, to a recieving list if the members are not yet represented in the receiver list
  """
  def add_to_list_if_missing(recieving_list, donor_list) do
    Enum.reduce(donor_list, recieving_list, fn donor, acc ->
      if Enum.member?(recieving_list, donor) == false do
        acc ++ [donor]
      else
        acc
      end
    end)
  end

  @spec halt_when_list_zero(map(), any()) :: {:cont, map()} | {:halt, map()}
  @doc """
  Helper function for use with reduce_while, where maps containing lists are used to determine if the algorithm should halt and return its input.

  This function compares the length of a retrieved list from a map, if it is equal to 0, the :halt is returned otherwise :cont
  """
  def halt_when_list_zero(map_with_lists, atom_to_check_len) do
    if length(Map.get(map_with_lists, atom_to_check_len)) == 0 do
      {:halt, map_with_lists}
    else
      {:cont, map_with_lists}
    end
  end

  @doc """
  For a given starting coordinate, iterate over connected neighboring members of its polygon.
  """
  def get_polygon_from_starting_point(queue, seen, collector, letter_list) do
    if length(queue) == 0 do
      collector
    else
      current = hd(queue)
      seen = seen ++ [current]
      next = tl(queue)
      neighbors = get_letter_neighbors(elem(current, 0), elem(current, 1), letter_list)

      enqueue =
        Enum.filter(add_to_list_if_missing(next, neighbors), fn neighbor ->
          Enum.member?(seen, neighbor) == false
        end)

      collected = add_to_list_if_missing(collector, neighbors)
      get_polygon_from_starting_point(enqueue, seen, collected, letter_list)
    end
  end

  @spec get_polygons_for_letter(map(), any()) :: any()
  @doc """
  For a given letter, identify all of the polygons in the grid.
  """
  def get_polygons_for_letter(letter_map, letter) do
    letter_coords = Map.get(letter_map, letter)

    Enum.reduce_while(
      0..length(letter_coords),
      %{:queue => letter_coords, :result => []},
      fn _, acc ->
        current_queue = Map.get(acc, :queue)
        current_results = Map.get(acc, :result)

        polygon_collected =
          get_polygon_from_starting_point(
            [hd(current_queue)],
            [],
            [hd(current_queue)],
            letter_coords
          )

        new_queue =
          Enum.filter(Map.get(acc, :queue), fn queued ->
            Enum.member?(polygon_collected, queued) == false
          end)

        remaining = %{:queue => new_queue, :result => current_results ++ [polygon_collected]}
        halt_when_list_zero(remaining, :queue)
      end
    )
  end

  @spec area(list()) :: non_neg_integer()
  @doc """
  Gets the "Area" occupied by a list of points
  """
  def area(polygon) do
    Enum.count(polygon)
  end

  @spec neighbors_count(tuple(), list()) :: integer()
  @doc """
  Calculates how many sides of this point of the polygon are exposed to the outside of the polygon.
  """
  def neighbors_count(point, polygon) do
    4 -
      Enum.count(
        Enum.filter(
          Utils.get_pot_next_steps(
            elem(point, 0),
            elem(point, 1),
            [:north, :south, :east, :west],
            1
          ),
          fn neighbor -> Enum.member?(polygon, neighbor) == true end
        )
      )
  end

  @spec perimeter(list()) :: integer()
  @doc """
  Calculates the "perimeter" of a polygon by adding the number of sides exposed to the outside.
  """
  def perimeter(polygon) do
    Enum.reduce(polygon, 0, fn point, acc ->
      acc + neighbors_count(point, polygon)
    end)
  end

  def cost(polygon) do
    perimeter(polygon) * area(polygon)
  end

  def all_region_cost(polygons) do
    Enum.sum(Enum.map(polygons, fn polygon -> cost(polygon) end))
  end

  def total_cost(grid_map) do
    Enum.reduce(Map.keys(grid_map), 0, fn letter, acc ->
      acc + all_region_cost(Map.get(get_polygons_for_letter(grid_map, letter), :result))
    end)
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    total_cost(Utils.generate_map_from_split_str(content))
  end
end
