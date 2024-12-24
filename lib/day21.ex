defmodule Day21 do



  def find_distance_for_move(current_move, previous_move, data_for_scoring) do
    previous_score = elem(previous_move, 2)
    instruction = Utils.direction_to_instruction(elem(current_move,1))
    previous_direction = Utils.direction_to_instruction(elem(previous_move,1))
    numbers_ran_once = punch_in_numbers(data_for_scoring, previous_direction, instruction,3,2, &Utils.a_star_default_scoring_function/3, data_for_scoring)
    numbers_ran = instruction_reduce(List.to_tuple(Enum.with_index(instruction_reduce(List.to_tuple(Enum.with_index(numbers_ran_once)),data_for_scoring, &Utils.a_star_default_scoring_function/3))),data_for_scoring, &Utils.a_star_default_scoring_function/3)
    previous_score + length(numbers_ran)
  end

  def get_directions_for_next_spot(current_spot, next_spot, walls, size_x,size_y, scoring_function, secondary_data) do
    a_star_results = Utils.a_star_with_options(
      [{current_spot, :east, 0, Utils.manhattan(current_spot, next_spot), []}],
      next_spot,
      [],
      walls,
      scoring_function,
      size_x+1,
      size_y+1,
      secondary_data, [])
    elem(a_star_results,4)
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
  def punch_in_numbers(number_map, current_number, next_number, size_x, size_y, scoring_function, secondary_data) do
    start_coord = hd(Map.get(number_map, current_number))
    end_coord= hd(Map.get(number_map, next_number))
    walls = Map.get(number_map, "#")
    directions = get_directions_for_next_spot(start_coord, end_coord, walls, size_x, size_y, scoring_function, secondary_data)
    history_to_instructions(directions)
  end

  def instruction_translate(pre_compute, instruction) do
    Map.get(pre_compute, instruction, [])
  end



  def instruction_reduce(instruction_list_tuple, pre_computed_buttons, scoring_function) do
    Enum.reduce(Enum.to_list(0..tuple_size(instruction_list_tuple)-1), [], fn index, acc ->
      instruction_pair = elem(instruction_list_tuple, index)
      instruction = elem(instruction_pair, 0)
      if index == 0 do
        acc++punch_in_numbers(pre_computed_buttons, "A", instruction, 3,2, scoring_function, pre_computed_buttons)
      else
        previous_instruction = elem(elem(instruction_list_tuple, index-1), 0)
        acc++punch_in_numbers(pre_computed_buttons, previous_instruction, instruction, 3,2,scoring_function, pre_computed_buttons)
      end

    end)
  end

  def instructions_to_instructions(instruction_list, pre_computed_buttons, depth) do
    instruction_list_tuple = List.to_tuple(Enum.with_index(instruction_list))
    case depth do
      d when d == 0 -> instruction_list
      d when d == 1 -> instruction_reduce(instruction_list_tuple, pre_computed_buttons, &find_distance_for_move/3)
      _ -> instructions_to_instructions(instruction_reduce(instruction_list_tuple, pre_computed_buttons, &find_distance_for_move/3), pre_computed_buttons, depth-1)
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
            number_pad_y,
            &find_distance_for_move/3,
            direction_pad)
        else
          acc++punch_in_numbers(
            number_pad,
            elem(elem(split, index-1),0),
            elem(elem(split, index),0),
            number_pad_x,
            number_pad_y,
            &find_distance_for_move/3,
            direction_pad)
      end
    end)
    instructions_to_instructions(numbers_reduced,direction_pad,2)

  end

end
