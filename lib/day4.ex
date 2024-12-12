defmodule Day4 do
  def parse_input(input_str) do
    Enum.map(
      String.split(input_str, "\n", trim: true),
      fn x -> String.split(x, "", trim: true) end
    )
  end

  def add_to_end(lst, row, column) do
    lst ++ [{elem(row, 1), elem(column, 1)}]
  end

  def add_r_c_to_map(map, key, row, column) do
    Map.update!(map, key, fn x -> add_to_end(x, row, column) end)
  end

  def column_runner(map, row) do
    column = Enum.with_index(elem(row, 0))

    Enum.reduce(column, map, fn column, acc ->
      add_r_c_to_map(acc, elem(column, 0), row, column)
    end)
  end

  def input_to_map(parsed_grid) do
    collect_map = %{"X" => [], "M" => [], "A" => [], "S" => []}

    Enum.reduce(
      Enum.with_index(parsed_grid),
      collect_map,
      fn row, acc -> column_runner(acc, row) end
    )
  end

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

  def direction_collector(start_row, start_column, letter_list, direction) do
    Enum.reduce(
      Enum.with_index(letter_list),
      %{},
      fn x, acc ->
        Map.put(
          acc,
          elem(x, 0),
          direction_operator(
            start_row,
            start_column,
            direction,
            elem(x, 1)
          )
        )
      end
    )
  end

  @doc """
  This function is intended to give a boolean response that the potential path is valid
  """
  def collected_points_registered(board_map, directions) do
    Enum.all?(directions, fn {k, v} -> Enum.member?(Map.get(board_map, k), v) end)
  end

  def collect_valid_directions_from_start(
        board_map,
        start_row,
        start_column,
        letter_list,
        direction_list
      ) do
    Enum.count(
      Enum.map(
        direction_list,
        fn x -> direction_collector(start_row, start_column, letter_list, x) end
      ),
      fn y -> collected_points_registered(board_map, y) == true end
    )
  end

  def find_all_xmas_from_x(board_map, letters) do
    Enum.sum(
      Enum.map(
        Map.get(board_map, "X"),
        fn x ->
          collect_valid_directions_from_start(
            board_map,
            elem(x, 0),
            elem(x, 1),
            letters,
            [
              :north,
              :south,
              :east,
              :west,
              :northeast,
              :northwest,
              :southeast,
              :southwest
            ]
          )
        end
      )
    )
  end

  def get_coords_for_x(start_row, start_column) do
    [
      [
        direction_operator(start_row, start_column, :northwest, 1),
        {start_row, start_column},
        direction_operator(start_row, start_column, :southeast, 1)
      ],
      [
        direction_operator(start_row, start_column, :northeast, 1),
        {start_row, start_column},
        direction_operator(start_row, start_column, :southwest, 1)
      ]
    ]
  end

  def has_letters_once(board_map, direction_coords) do
    first = List.first(direction_coords)
    last = List.last(direction_coords)

    forward =
      Enum.count(Map.get(board_map, "M"), fn x -> x == first end) +
        Enum.count(Map.get(board_map, "S"), fn x -> x == last end)

    backward =
      Enum.count(Map.get(board_map, "M"), fn x -> x == last end) +
        Enum.count(Map.get(board_map, "S"), fn x -> x == first end)

    forward == 2 or backward == 2
  end

  def check_x(board_map, start_row, start_column) do
    Enum.all?(get_coords_for_x(start_row, start_column), fn x ->
      has_letters_once(board_map, x)
    end)
  end

  def all_x_s(board_map) do
    Enum.count(Map.get(board_map, "A"), fn x ->
      check_x(board_map, elem(x, 0), elem(x, 1)) == true
    end)
  end

  def part1(filename) do
    {:ok, contents} = File.read(filename)
    find_all_xmas_from_x(input_to_map(parse_input(contents)), ["X", "M", "A", "S"])
  end

  def part2(filename) do
    {:ok, contents} = File.read(filename)
    all_x_s(input_to_map(parse_input(contents)))
  end
end
