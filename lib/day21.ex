defmodule Day21 do

  def instruction_length_scoring_function(_, new_point) do

  end

  def get_directions_for_next_spot(current_spot, next_spot, walls, size_x,size_y) do
    elem(Utils.a_star(
      [{current_spot, :east, 0, Utils.manhattan(current_spot, next_spot), []}],
      next_spot,
      [],
      walls,
      &Utils.a_star_default_scoring_function/2,
      size_x+1,
      size_y+1),
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

  def pre_computed_map_buttons(number_map, button_labels, size_x, size_y) do

      mapped_labels = for x <- button_labels, y <- button_labels, x != y, do: [x,y]
      Enum.reduce(mapped_labels, %{}, fn [x,y], acc ->
        Map.put(acc, "#{x},#{y}", punch_in_numbers(number_map, x, y, size_x, size_y))
      end)
    end

  @doc """
  Given a map of where all the numbers are, the current_number, and the next number, plot out the robot movements
  """
  def punch_in_numbers(number_map, current_number, next_number, size_x, size_y) do
    start_coord = hd(Map.get(number_map, current_number))
    end_coord= hd(Map.get(number_map, next_number))
    walls = Map.get(number_map, "#")
    get_directions_for_next_spot(start_coord, end_coord, walls, size_x, size_y)
    |>history_to_instructions()
  end

  def instruction_translate(pre_compute, instruction) do
    Map.get(pre_compute, instruction, [])
  end

  def instruction_reduce(instruction_list_tuple, pre_computed_buttons) do
    Enum.reduce(Enum.to_list(0..tuple_size(instruction_list_tuple)-1), [], fn index, acc ->
      instruction_pair = elem(instruction_list_tuple, index)
      instruction = elem(instruction_pair, 0)
      if index == 0 do
        acc++punch_in_numbers(pre_computed_buttons, "A", instruction, 3,2)
      else
        previous_instruction = elem(elem(instruction_list_tuple, index-1), 0)
        acc++punch_in_numbers(pre_computed_buttons, previous_instruction, instruction, 3,2)
      end

    end)
  end

  def instructions_to_instructions(instruction_list, pre_computed_buttons, depth) do
    instruction_list_tuple = List.to_tuple(Enum.with_index(instruction_list))
    if depth == 1 do
      instruction_reduce(instruction_list_tuple, pre_computed_buttons)
    else
      instructions_to_instructions(instruction_reduce(instruction_list_tuple, pre_computed_buttons), pre_computed_buttons, depth-1)
    end

  end

  def get_full_robot_list(input_number) do
    number_pad = Utils.generate_map_from_split_str("789\n654\n321\n#0A")
    direction_pad = Utils.generate_map_from_split_str( "#^A\n<v>")
    {number_pad_x, number_pad_y} = {3,4}

    split = String.split(input_number, "", trim: true)
    |> Enum.with_index() |> List.to_tuple()
    numbers_reduced = Enum.reduce(
      Enum.to_list(0..tuple_size(split)-1),
      [],
      fn index, acc ->
        if index == 0 do
          acc++punch_in_numbers(
            number_pad,
            "A",
            elem(elem(split, index),0),
            number_pad_x,
            number_pad_y)
        else
          acc++punch_in_numbers(
            number_pad,
            elem(elem(split, index-1),0),
            elem(elem(split, index),0),
            number_pad_x,
            number_pad_y)
      end
    end)
    instruction_1 = instructions_to_instructions(numbers_reduced,direction_pad)
    instructions_to_instructions(instruction_1,direction_pad)
  end

end
