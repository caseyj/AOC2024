defmodule Day21 do

  def get_directions_for_next_spot(current_spot, next_spot, walls) do
    elem(Utils.a_star(
      [{current_spot, :east, 0, Utils.manhattan(current_spot, next_spot), []}],
      next_spot,
      [],
      walls,
      &Utils.a_star_default_scoring_function/2,
      4,
      3),
      4)
  end

  @doc """
  translates all of the history information
  """
  def history_to_instructions(history) do
    Enum.reduce(Enum.with_index(history), [], fn historia, acc ->
      if elem(historia,1) >0 do
        acc++[Utils.direction_to_instruction(elem(elem(historia,0), 1))]
      else
        acc
      end
    end)++["A"]
  end

  @doc """
  Given a map of where all the numbers are, the current_number, and the next number, plot out the robot movements
  """
  def punch_in_numbers(number_map, current_number, next_number) do
    start_coord = hd(Map.get(number_map, current_number))
    end_coord= hd(Map.get(number_map, next_number))
    get_directions_for_next_spot(start_coord, end_coord, [{3,0}])
    |>history_to_instructions()
  end



end
