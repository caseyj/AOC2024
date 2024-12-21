defmodule Utils do
  @spec to_int(binary()) :: integer()
  def to_int(int) do
    String.to_integer(int)
  end

  @doc """
  Gets the next position from a starting coordinate, direction, and number of spaces.
  """
  @spec direction_operator(
          integer(),
          integer(),
          :north | :northeast | :east | :southeast | :south | :southwest | :west | :northwest,
          integer()
        ) :: {integer(), integer()}
  def direction_operator(start_row, start_column, direction, distance) do
    if distance == 0 do
      {start_row, start_column}
    else
      case direction do
        x when x == :north ->
          direction_operator(start_row - 1, start_column, direction, distance - 1)

        x when x == :south ->
          direction_operator(start_row + 1, start_column, direction, distance - 1)

        x when x == :east ->
          direction_operator(start_row, start_column + 1, direction, distance - 1)

        x when x == :west ->
          direction_operator(start_row, start_column - 1, direction, distance - 1)

        x when x == :northeast ->
          direction_operator(start_row - 1, start_column + 1, direction, distance - 1)

        x when x == :northwest ->
          direction_operator(start_row - 1, start_column - 1, direction, distance - 1)

        x when x == :southeast ->
          direction_operator(start_row + 1, start_column + 1, direction, distance - 1)

        x when x == :southwest ->
          direction_operator(start_row + 1, start_column - 1, direction, distance - 1)
      end
    end
  end

  def check_on_map(row, column, size_x, size_y) do
    if row >= 0 and row < size_x and (column >= 0 and column < size_y) do
      true
    else
      false
    end
  end

  @spec map_append_lists(map(), any(), any()) :: map()
  @doc """
  function automates adding elements to a map between arbitrary keys and lists at that key.

  Assumes the default value for any key of a map is an empty list
  """
  def map_append_lists(map, key, list) do
    Map.put(map, key, Map.get(map, key, []) ++ list)
  end

  @spec parse_string_to_two_tuple(binary()) :: tuple()
  @doc """
  Parses a string first by newlines, then by each element in each resuling string
  This function is exceptionally useful for building grid datastructures

  Example:
  "123\\n456" -> {{"1",2,3},{4,5,6}}
  """
  def parse_string_to_two_tuple(str) do
    List.to_tuple(
      Enum.map(String.split(str, "\n", trim: true), fn x ->
        List.to_tuple(String.split(x, "", trim: true))
      end)
    )
  end

  @doc """
  Parses a string first by newlines, then by each element in each resuling string
  This function is exceptionally useful for building grid datastructures

  Example:
  "123\\n456" -> {{1,2,3},{4,5,6}}
  """
  def parse_string_to_two_tuple(str, element_fn) do
    List.to_tuple(
      Enum.map(String.split(str, "\n", trim: true), fn x ->
        List.to_tuple(Enum.map(String.split(x, "", trim: true), fn x -> element_fn.(x) end))
      end)
    )
  end

  @spec get_pot_next_steps(
          integer(),
          integer(),
          :north | :northeast | :east | :southeast | :south | :southwest | :west | :northwest,
          integer()
        ) :: tuple()
  @doc """
  From a list of directions and a distance, this function will return a list
  of the next two-tuple pairs of points with no filtering on validity
  """
  def get_pot_next_steps(row, column, directions, distance) do
    Enum.reduce(directions, [], fn x, acc ->
      acc ++ [Utils.direction_operator(row, column, x, distance)]
    end)
  end

  @spec get_value_from_2d_tuple(tuple(), non_neg_integer(), non_neg_integer()) :: any()
  @doc """
  Assists in retrieving values from 2d tuple matrices
  """
  def get_value_from_2d_tuple(matrix, row, column) do
    elem(elem(matrix, row), column)
  end

  def print_tuple(tup) do
    "{#{Enum.join(Tuple.to_list(tup), ",")}}"
  end

  @spec generate_map_from_split_str(binary()) :: map()
  @doc """
  This tool generates a map of detected objects and their coordinate pairs listed as {row#, column#}
  The example map will give you %{"#"=>[{0,1},{2,2}], "S"=>[{0,5}]...}
  """
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
                  Map.get(acc, elem(element, 0), []) ++ [{elem(element, 1), elem(line, 1)}]
                )
            end
          end
        )
      end
    )
  end

  @doc """
  An arbitrary Euclidean distance function that takes two, equally sized tuples and gives the L2 distance
  """
  def distance(current_point, target) do
    :math.sqrt(
      Enum.reduce(Enum.zip(Tuple.to_list(current_point), Tuple.to_list(target)), 0, fn {x1, x2},
                                                                                       acc ->
        acc + :math.pow(x2 - x1, 2)
      end)
    )
  end

  @doc """
  Gives the manhattan distancce  between two equally sized tuples.
  """
  def manhattan(current_point, target) do
    Enum.reduce(Enum.zip(Tuple.to_list(current_point), Tuple.to_list(target)), 0, fn {x1, x2},
                                                                                     acc ->
      acc + abs(x2 - x1)
    end)
  end

  @doc """
  Given a list of objects that might be members of other lists, and the list of lists those objects are potentially in, filter the first list of objects down to only the objects that are not members of any list.

  This function assumes the points list is a set of point objects that look like this
  {{x,y}, :direction} and the {x,y} element is what cannot appear in other lists
  """
  def filter_elements_from_multiple_lists(points, lists) do
    if lists == [] do
      points
    else
      survivors =
        Enum.reduce(lists, points, fn list, acc ->
          Enum.filter(acc, fn point ->
            pt = elem(point, 0)
            member = Enum.member?(list, pt)
            member == false
          end)
        end)

      survivors
    end
  end

  @doc """
  A heuristic for sorting assuming its between two tuples with a minimum of 4 constituent elements have
  """
  @spec heuristic(tuple(), tuple()) :: boolean()
  def heuristic(object_a, object_b) do
    a_score = elem(object_a, 2) + elem(object_a, 3)
    b_score = elem(object_b, 2) + elem(object_b, 3)
    a_score < b_score
  end

  @doc """
  A largely generalized A star algorithm that assumes each element in the search is in the format
  {{x, y}, direction, score, distance, history}

  """
  def a_star(queue, target, seen, walls, scoring_function, size_x, size_y) do
    {{x, y}, direction, score, distance, history} = hd(queue)

    if {x, y} == target do
      {{x, y}, direction, score, distance, history++[{{x, y}, direction}]}
    else
      queue_point_list = Enum.reduce(queue, [], fn q, acc -> acc ++ [elem(q, 0)] end)

      points =
        Enum.map([:north, :south, :east, :west], fn next_direction ->
          {y, x} = direction_operator(y, x, next_direction, 1)
          {{x, y}, next_direction}
        end)
        |> filter_elements_from_multiple_lists([queue_point_list, seen, walls])
        |> Enum.filter(fn {{column, row}, _} ->
          check_on_map(row, column, size_x, size_y) == true
        end)
        |> Enum.map(fn {point, new_direction} ->
          {point, new_direction, scoring_function.({point, new_direction}, hd(queue)), manhattan(point, target), history ++ [{{x, y}, direction}]}
        end)

      new_queue = Enum.sort(tl(queue) ++ points, &heuristic(&1, &2))
      a_star(new_queue, target, seen ++ [{x, y}], walls, scoring_function, size_x, size_y)
    end
  end

  @doc """
  Scoring function that adds a point every step taken

  Assumes the third element of the `previous_point` tuple is an integer
  """
  def a_star_default_scoring_function(_, previous_point) do
    elem(previous_point, 2)+1
  end

  @doc """
  Runs the a_star implementation with the default scoring function, and assuming the x,y size of the board is the target's x,y coordinate
  """
  def a_star(queue, target, seen, walls) do
    a_star(queue, target, seen, walls, &a_star_default_scoring_function/2, elem(target, 0) + 1, elem(target, 1) + 1)
  end

  @spec instruction_to_direction(any()) :: :east | :north | :south | :west
  @doc """
  Gives the correct direction for each instruction provided
  """
  def instruction_to_direction(direction) do
    case direction do
      x when x == "^" -> :north
      x when x == ">" -> :east
      x when x == "<" -> :west
      x when x == "v" -> :south
    end
  end

  @spec direction_to_instruction(:east | :north | :south | :west) :: <<_::8>>
  @doc """
  Gives the correct direction for each instruction provided
  """
  def direction_to_instruction(direction) do
    case direction do
      x when x == :north -> "^"
      x when x == :east -> ">"
      x when x == :west  -> "<"
      x when x == :south  -> "v"
    end
  end

end
