defmodule Day13 do
  def determinant(first_pair, second_pair) do
    mult_first_diag = elem(first_pair, 0) * elem(second_pair, 1)
    mult_second_diag = elem(first_pair, 1) * elem(second_pair, 0)
    mult_first_diag - mult_second_diag
  end

  def construct_top_level(
        first_pair,
        second_pair,
        x_solution,
        y_solution,
        solve_for
      ) do
    case solve_for do
      x when x == :x ->
        {
          {x_solution, elem(first_pair, 1)},
          {y_solution, elem(second_pair, 1)}
        }

      x when x == :y ->
        {
          {elem(first_pair, 0), x_solution},
          {elem(second_pair, 0), y_solution}
        }
    end
  end

  @spec get_solution(tuple(), tuple(), any(), any(), :x | :y) :: integer()
  def get_solution(
        first_pair,
        second_pair,
        x_solution,
        y_solution,
        solve_for
      ) do
    top_level = construct_top_level(first_pair, second_pair, x_solution, y_solution, solve_for)
    det = determinant(first_pair, second_pair)
    det_top = determinant(elem(top_level, 0), elem(top_level, 1))

    if rem(det_top, det) != 0 do
      0
    else
      div(det_top, det)
    end
  end

  def get_button_presses(
        first_pair,
        second_pair,
        x_solution,
        y_solution
      ) do
    %{
      :x => get_solution(first_pair, second_pair, x_solution, y_solution, :x),
      :y => get_solution(first_pair, second_pair, x_solution, y_solution, :y)
    }
  end

  def calculate_win(
        first_pair,
        second_pair,
        x_solution,
        y_solution
      ) do
    button_presses =
      get_button_presses(
        first_pair,
        second_pair,
        x_solution,
        y_solution
      )

    Enum.reduce_while(button_presses, 0, fn {k, v}, acc ->
      if v <= 100 and v >= 1 do
        case k do
          x when x == :x -> {:cont, acc + 3 * v}
          x when x == :y -> {:cont, acc + v}
        end
      else
        {:halt, 0}
      end
    end)
  end

  def calculate_win_2(
        first_pair,
        second_pair,
        x_solution,
        y_solution
      ) do
    button_presses =
      get_button_presses(
        first_pair,
        second_pair,
        x_solution + 10_000_000_000_000,
        y_solution + 10_000_000_000_000
      )

    Enum.reduce_while(button_presses, 0, fn {k, v}, acc ->
      if v >= 1 do
        case k do
          x when x == :x -> {:cont, acc + 3 * v}
          x when x == :y -> {:cont, acc + v}
        end
      else
        {:halt, 0}
      end
    end)
  end

  def parse_blocks(str) do
    String.split(str, "\n\n", trim: true)
  end

  def assemble_equation(line1_tuple, line2_tuple) do
    {
      {
        elem(line1_tuple, 0),
        elem(line2_tuple, 0)
      },
      {elem(line1_tuple, 1), elem(line2_tuple, 1)}
    }
  end

  def calculate_block_val2(string_block) do
    lines =
      List.to_tuple(
        Enum.reduce(String.split(string_block, "\n", trim: true), [], fn line, acc ->
          acc ++ [line_extract(line)]
        end)
      )

    assembled_equation = assemble_equation(elem(lines, 0), elem(lines, 1))

    calculate_win_2(
      elem(assembled_equation, 0),
      elem(assembled_equation, 1),
      elem(elem(lines, 2), 0),
      elem(elem(lines, 2), 1)
    )
  end

  def calculate_block_val(string_block) do
    lines =
      List.to_tuple(
        Enum.reduce(String.split(string_block, "\n", trim: true), [], fn line, acc ->
          acc ++ [line_extract(line)]
        end)
      )

    assembled_equation = assemble_equation(elem(lines, 0), elem(lines, 1))

    calculate_win(
      elem(assembled_equation, 0),
      elem(assembled_equation, 1),
      elem(elem(lines, 2), 0),
      elem(elem(lines, 2), 1)
    )
  end

  @spec line_extract(binary()) :: {integer(), integer()}
  def line_extract(str) do
    captured = Regex.named_captures(~r/[X][=|+](?<X>\d+)\W+[Y][=|+](?<Y>\d+)/, str)
    {Utils.to_int(Map.get(captured, "X")), Utils.to_int(Map.get(captured, "Y"))}
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    Enum.sum(Enum.map(parse_blocks(content), fn block -> calculate_block_val(block) end))
  end

  def part2(filename) do
    {:ok, content} = File.read(filename)
    Enum.sum(Enum.map(parse_blocks(content), fn block -> calculate_block_val2(block) end))
  end
end
