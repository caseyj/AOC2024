defmodule Day13Test do
  use ExUnit.Case

  for {first_pair, second_pair, expected} <- [
        {{94, 22}, {34, 67}, 5550},
        {{26, 67}, {66, 21}, -3876},
        {{17, 84}, {86, 37}, -6595},
        {{69, 27}, {23, 71}, 4278},
        {{4, 1}, {0, 2}, 8}
      ] do
    test "Check find determinant #{Utils.print_tuple(first_pair)}, #{Utils.print_tuple(second_pair)}, expected #{expected}" do
      assert Day13.determinant(unquote(first_pair), unquote(second_pair)) == unquote(expected)
    end
  end

  for {first_pair, second_pair, x_solution, y_solution, solve_for, expected} <- [
        {{94, 22}, {34, 67}, 8400, 5400, :x, {{8400, 22}, {5400, 67}}},
        {{94, 22}, {34, 67}, 8400, 5400, :y, {{94, 8400}, {34, 5400}}},
        {{26, 67}, {66, 21}, 12748, 12176, :x, {{12748, 67}, {12176, 21}}},
        {{26, 67}, {66, 21}, 12748, 12176, :y, {{26, 12748}, {66, 12176}}},
        {{17, 84}, {86, 37}, 7870, 6450, :x, {{7870, 84}, {6450, 37}}},
        {{17, 84}, {86, 37}, 7870, 6450, :y, {{17, 7870}, {86, 6450}}},
        {{69, 27}, {23, 71}, 18641, 10279, :x, {{18641, 27}, {10279, 71}}},
        {{69, 27}, {23, 71}, 18641, 10279, :y, {{69, 18641}, {23, 10279}}}
      ] do
    test "Check construct_top_level #{Utils.print_tuple(first_pair)}, #{Utils.print_tuple(second_pair)}, x_solution#{x_solution}, y_solution #{y_solution}, solving for#{solve_for}" do
      assert Day13.construct_top_level(
               unquote(first_pair),
               unquote(second_pair),
               unquote(x_solution),
               unquote(y_solution),
               unquote(solve_for)
             ) == unquote(expected)
    end
  end

  for {first_pair, second_pair, x_solution, y_solution, solve_for, expected} <- [
        {{94, 22}, {34, 67}, 8400, 5400, :x, 80},
        {{94, 22}, {34, 67}, 8400, 5400, :y, 40},
        {{26, 67}, {66, 21}, 12748, 12176, :x, 0},
        {{26, 67}, {66, 21}, 12748, 12176, :y, 0},
        {{17, 84}, {86, 37}, 7870, 6450, :x, 38},
        {{17, 84}, {86, 37}, 7870, 6450, :y, 86},
        {{69, 27}, {23, 71}, 18641, 10279, :x, 0},
        {{69, 27}, {23, 71}, 18641, 10279, :y, 0}
      ] do
    test "Check get_solution #{Utils.print_tuple(first_pair)}, #{Utils.print_tuple(second_pair)}, x_solution#{x_solution}, y_solution #{y_solution}, solving for#{solve_for}" do
      assert Day13.get_solution(
               unquote(first_pair),
               unquote(second_pair),
               unquote(x_solution),
               unquote(y_solution),
               unquote(solve_for)
             ) == unquote(expected)
    end
  end

  for {first_pair, second_pair, x_solution, y_solution, expected} <- [
        {{94, 22}, {34, 67}, 8400, 5400, 280},
        {{26, 67}, {66, 21}, 12748, 12176, 0},
        {{17, 84}, {86, 37}, 7870, 6450, 200},
        {{69, 27}, {23, 71}, 18641, 10279, 0}
      ] do
    test "Check calculate_win #{Utils.print_tuple(first_pair)}, #{Utils.print_tuple(second_pair)}, x_solution#{x_solution}, y_solution #{y_solution}" do
      assert Day13.calculate_win(
               unquote(first_pair),
               unquote(second_pair),
               unquote(x_solution),
               unquote(y_solution)
             ) == unquote(expected)
    end
  end

  for {input, expected} <- [
        {"Button A: X+94, Y+34", {94, 34}},
        {"Button B: X+22, Y+67", {22, 67}},
        {"Prize: X=8400, Y=5400", {8400, 5400}}
      ] do
    test "Check line_extract #{input} is parsed correctly" do
      assert Day13.line_extract(unquote(input)) == unquote(expected)
    end
  end

  test "assemble_equation" do
    assert Day13.assemble_equation({94, 34}, {22, 67}) == {{94, 22}, {34, 67}}
  end

  test "Check calculate_block_val" do
    assert Day13.calculate_block_val(
             "Button A: X+94, Y+34\nButton B: X+22, Y+67\nPrize: X=8400, Y=5400"
           ) == 280
  end

  test "Part 1 working" do
    assert Day13.part1("data/day13_sample.txt") == 480
  end
end
