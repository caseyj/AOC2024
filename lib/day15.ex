defmodule Day15 do
  def instruction_to_direction(direction) do
    case direction do
      x when x == "^" -> :north
      x when x == ">" -> :east
      x when x == "<" -> :west
      x when x == "v" -> :south
    end
  end

  def wall_collision(new_coords, wall_list) do
    all_vals =
      Enum.map(
        new_coords,
        fn x ->
          Enum.member?(wall_list, x) == true
        end
      )

    Enum.any?(all_vals)
  end

  @doc """
  This function gets the next spot for an arbitrary moving object(s).

  As boxes are hit, we run the same function on them and we create a running list of potential updates
  """
  def box_collision(object_coords, direction, box_list) do
    new_spot =
      Utils.direction_operator(
        elem(object_coords, 0),
        elem(object_coords, 1),
        instruction_to_direction(direction),
        1
      )

    if new_spot in box_list do
      [new_spot] ++ box_collision(new_spot, direction, box_list)
    else
      [new_spot]
    end
  end

  def update_box_list(collisions, box_list) do
    new_robot_spot = hd(collisions)

    if length(collisions) == 1 do
      {new_robot_spot, box_list}
    else
      add_spots =
        Enum.reduce(tl(collisions), [], fn x, acc ->
          if Enum.member?(box_list, x) do
            acc
          else
            acc ++ [x]
          end
        end)

      {new_robot_spot, List.delete(box_list ++ add_spots, new_robot_spot)}
    end
  end

  def determine_list(robot_start_coords, direction, wall_list, box_list) do
    if direction != "\n" do
      collisions = box_collision(robot_start_coords, direction, box_list)

      if wall_collision(collisions, wall_list) do
        {robot_start_coords, box_list}
      else
        update_box_list(collisions, box_list)
      end
    else
      {robot_start_coords, box_list}
    end
  end

  def intake(str) do
    split = String.split(str, "\n\n", trim: true)
    locations_map = Utils.generate_map_from_split_str(hd(split))
    directions = String.split(hd(tl(split)), "", trim: true)
    {locations_map, directions}
  end

  def run_instructions(intake_tuple) do
    instructions = elem(intake_tuple, 1)
    position_map = elem(intake_tuple, 0)
    robot = hd(Map.get(position_map, "@"))
    walls = Map.get(position_map, "#")
    boxes = Map.get(position_map, "O")

    Enum.reduce(instructions, {robot, boxes}, fn instruction, acc ->
      determine_list(elem(acc, 0), instruction, walls, elem(acc, 1))
    end)
  end

  def get_coordinate_sums(run_results) do
    Enum.reduce(elem(run_results, 1), 0, fn coord, acc ->
      acc + 100 * elem(coord, 0) + elem(coord, 1)
    end)
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    get_coordinate_sums(run_instructions(intake(content)))
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)
    IO.puts("NOT YET IMPLEMENTED")
  end
end
