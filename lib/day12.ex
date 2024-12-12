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

  @spec get_polygon_from_starting_point(any(), list()) :: any()
  @doc """
  For a given starting coordinate, iterate over connected neighboring members of its polygon.
  """
  def get_polygon_from_starting_point(starting_coord, letter_list) do
    Enum.reduce_while(
      0..length(letter_list),
      %{:queue => [starting_coord], :collected => [starting_coord]},
      fn _, acc ->
        current = hd(Map.get(acc, :queue))
        next = tl(Map.get(acc, :queue))
        neighbors = get_letter_neighbors(elem(current, 0), elem(current, 1), letter_list)
        enqueue = add_to_list_if_missing(next, neighbors)
        collected = add_to_list_if_missing(Map.get(acc, :collected), neighbors)
        remaining = %{:queue => enqueue, :collected => collected}
        halt_when_list_zero(remaining, :queue)
      end
    )
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
      fn coord, acc ->
        current_results = Map.get(acc, :result)
        polygon_result_map = get_polygon_from_starting_point(coord, letter_coords)
        polygon_collected = Map.get(polygon_result_map, :collected)

        new_queue =
          Enum.filter(Map.get(acc, :queue), fn queued ->
            Enum.member?(polygon_collected, queued) == false
          end)

        remaining = %{:queue => new_queue, :result => current_results ++ [polygon_collected]}
        halt_when_list_zero(remaining, :queue)
      end
    )
  end
end
