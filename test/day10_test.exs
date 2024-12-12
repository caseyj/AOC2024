defmodule Day10Test do
  use ExUnit.Case

  for {row, column, previous_row, previous_column, expected} <- [
        {0, 0, 0, 0, false},
        {0, 0, 1, 1, true}
      ] do
    test "Check not_previous_steps #{row}, #{column}, #{previous_row}, #{previous_column} #{expected}" do
      assert Day10.not_previous_steps(
               unquote(row),
               unquote(column),
               unquote(previous_row),
               unquote(previous_column)
             ) == unquote(expected)
    end
  end

  for {row, column, previous_row, previous_column, expected} <- [
        {0, 0, 0, 1, false},
        {0, 0, 1, 1, false},
        {0, 0, 1, 0, false},
        {1, 1, 1, 0, true}
      ] do
    test "Check next_spot_climbable #{row}, #{column}, #{previous_row}, #{previous_column} #{expected}" do
      assert Day10.next_spot_climbable(
               {{0, 0}, {1, 2}},
               unquote(row),
               unquote(column),
               unquote(previous_row),
               unquote(previous_column)
             ) == unquote(expected)
    end
  end

  for {row, column, current_row, current_column, previous_row, previous_column, expected} <- [
        {1, 1, 0, 1, 0, 0, true},
        {2, 1, 1, 1, 0, 1, false},
        {1, 1, 0, 1, 1, 1, false}
      ] do
    test "Check check_step_for_validity #{row}, #{column}, #{current_row}, #{current_column},#{previous_row}, #{previous_column} #{expected}" do
      assert Day10.check_step_for_validity(
               {{0, 1, 1}, {1, 2, 1}, {9, 0, 1}},
               unquote(row),
               unquote(column),
               unquote(current_row),
               unquote(current_column),
               unquote(previous_row),
               unquote(previous_column)
             ) == unquote(expected)
    end
  end

  test "Check conduct_path" do
    matrix =
      Utils.parse_string_to_two_tuple(
        "9990999\n9991999\n9992999\n6543456\n7000007\n8000008\n9000009",
        &Utils.to_int/1
      )

    assert Map.get(Day10.conduct_path(0, 3, matrix), :paths_counter) == 2
  end

  test "Check part 1 works" do
    assert Day10.part1("data/day10_sample.txt") == 36
  end
end
