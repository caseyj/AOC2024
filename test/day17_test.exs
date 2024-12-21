defmodule Day17Test do
  use ExUnit.Case, async: true

  for {operand, expected} <- [
        {0, 0},
        {1, 1},
        {2, 2},
        {3, 3},
        {4, 7},
        {5, 8},
        {6, 9}
      ] do
    test "Check combo_operand #{operand}" do
      {:ok, agent} = Day17.initialize_registers()

      Enum.reduce(%{"C" => 9, "B" => 8, "A" => 7}, :ok, fn {k, v}, _ ->
        KV.put(agent, k, v)
        :ok
      end)

      assert Day17.combo_operand(unquote(operand), agent) == unquote(expected)
    end
  end

  test "Check first test" do
    {:ok, agent} = Day17.initialize_registers()

    Enum.reduce(%{"C" => 9}, :ok, fn {k, v}, _ ->
      KV.put(agent, k, v)
      :ok
    end)

    Day17.run_program(agent, {2, 6})
    assert KV.get(agent, "B") == 1
  end

  test "Check second test" do
    {:ok, agent} = Day17.initialize_registers()

    Enum.reduce(%{"A" => 10}, :ok, fn {k, v}, _ ->
      KV.put(agent, k, v)
      :ok
    end)

    assert Day17.run_program(agent, {5, 0, 5, 1, 5, 4}) == "0,1,2"
  end

  test "Check third test" do
    {:ok, agent} = Day17.initialize_registers()

    Enum.reduce(%{"A" => 2024}, :ok, fn {k, v}, _ ->
      KV.put(agent, k, v)
      :ok
    end)

    assert Day17.run_program(agent, {0, 1, 5, 4, 3, 0}) == "4,2,5,6,7,7,7,7,3,1,0"
    assert KV.get(agent, "A") == 0
  end

  test "Check fourth test" do
    {:ok, agent} = Day17.initialize_registers()

    Enum.reduce(%{"B" => 29}, :ok, fn {k, v}, _ ->
      KV.put(agent, k, v)
      :ok
    end)

    Day17.run_program(agent, {1, 7})
    assert KV.get(agent, "B") == 26
  end

  test "Check fifth test" do
    {:ok, agent} = Day17.initialize_registers()

    Enum.reduce(%{"B" => 2024, "C" => 43690}, :ok, fn {k, v}, _ ->
      KV.put(agent, k, v)
      :ok
    end)

    Day17.run_program(agent, {4, 0})
    assert KV.get(agent, "B") == 44354
  end

  test "program_to_tuple" do
    assert Day17.program_to_tuple("Program: 0,1,5,4,3,0") == {0, 1, 5, 4, 3, 0}
  end

  test "program_regex" do
    test_str = "Register A: 729\nRegister B: 0\nRegister C: 0\n\nProgram: 0,1,5,4,3,0"
    {:ok, agent} = Day17.initialize_registers()
    program = Day17.program_regex(test_str, agent)
    assert program == {0, 1, 5, 4, 3, 0}
    assert KV.get(agent, "A") == 729
    assert KV.get(agent, "B") == 0
    assert KV.get(agent, "C") == 0
  end

  test "part 1" do
    assert Day17.part1("data/day17_sample.txt") == "4,6,3,5,6,3,5,2,1,0"
  end
end
