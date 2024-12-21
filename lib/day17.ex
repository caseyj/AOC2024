defmodule Day17 do
  def combo_operand(operand, agent) do
    case operand do
      x when x >= 0 and x <= 3 -> x
      x when x == 4 -> KV.get(agent, "A")
      x when x == 5 -> KV.get(agent, "B")
      x when x == 6 -> KV.get(agent, "C")
    end
  end

  def adv(agent, operand) do
    a_val = KV.get(agent, "A")
    divisor = :math.pow(2, combo_operand(operand, agent))
    KV.put(agent, "A", floor(div(floor(a_val), floor(divisor))))
    {:ok}
  end

  def bxl(agent, operand) do
    KV.put(agent, "B", Bitwise.bxor(KV.get(agent, "B"), operand))
    {:ok}
  end

  def bst(agent, operand) do
    comb = combo_operand(operand, agent)
    KV.put(agent, "B", rem(floor(comb), 8))
    {:ok}
  end

  def jnz(agent, operand) do
    if KV.get(agent, "A") != 0 do
      KV.put(agent, "instruction_pointer", operand)
      KV.put(agent, "jmp", true)
      {:ok}
    else
      {:ok}
    end
  end

  def bxc(agent, _) do
    KV.put(agent, "B", Bitwise.bxor(KV.get(agent, "B"), KV.get(agent, "C")))
    {:ok}
  end

  def out(agent, operand) do
    KV.put(agent, "out", KV.get(agent, "out") ++ [rem(combo_operand(operand, agent), 8)])
    {:ok}
  end

  def bdv(agent, operand) do
    a_val = KV.get(agent, "A")
    divisor = :math.pow(2, combo_operand(operand, agent))
    KV.put(agent, "B", floor(div(a_val, floor(divisor))))
    {:ok}
  end

  def cdv(agent, operand) do
    a_val = KV.get(agent, "A")
    divisor = :math.pow(2, combo_operand(operand, agent))
    KV.put(agent, "B", floor(div(a_val, floor(divisor))))
    {:ok}
  end

  def operate_instructions(opcode, operand, agent) do
    case opcode do
      op when op == 0 -> adv(agent, operand)
      op when op == 1 -> bxl(agent, operand)
      op when op == 2 -> bst(agent, operand)
      op when op == 3 -> jnz(agent, operand)
      op when op == 4 -> bxc(agent, operand)
      op when op == 5 -> out(agent, operand)
      op when op == 6 -> bdv(agent, operand)
      op when op == 7 -> cdv(agent, operand)
    end
  end

  def initialize_registers() do
    {:ok, agent} = KV.start()
    KV.put(agent, "A", 0)
    KV.put(agent, "B", 0)
    KV.put(agent, "C", 0)
    KV.put(agent, "instruction_pointer", 0)
    KV.put(agent, "out", [])
    KV.put(agent, "jmp", false)
    {:ok, agent}
  end

  def increment_instruction_pointer(agent) do
    if KV.get(agent, "jmp") do
      KV.put(agent, "jmp", false)
    else
      KV.put(agent, "instruction_pointer", KV.get(agent, "instruction_pointer") + 2)
    end
  end

  def program_to_tuple(str) do
    init_split = hd(tl(String.split(str, ": ", trim: true)))

    List.to_tuple(
      Enum.map(String.split(init_split, ",", trim: true), fn x -> Utils.to_int(x) end)
    )
  end

  def program_regex(str, agent) do
    capture_map =
      Regex.named_captures(
        ~r/Register A: (?<A>\d+)\W+Register B: (?<B>\d+)\W+Register C: (?<C>\d+)\W+Program: (?<program>.*)/,
        str
      )

    Enum.reduce(["A", "B", "C"], :ok, fn letter, _ ->
      KV.put(agent, letter, Utils.to_int(Map.get(capture_map, letter)))
    end)

    List.to_tuple(
      Enum.map(String.split(Map.get(capture_map, "program"), ",", trim: true), fn x ->
        Utils.to_int(x)
      end)
    )
  end

  def run_program(agent, instructions) do
    instruction = KV.get(agent, "instruction_pointer")
    operand = instruction + 1

    if instruction >= tuple_size(instructions) do
      Enum.join(KV.get(agent, "out"), ",")
    else
      {:ok} =
        operate_instructions(elem(instructions, instruction), elem(instructions, operand), agent)

      increment_instruction_pointer(agent)
      run_program(agent, instructions)
    end
  end

  def part1(filename) do
    {:ok, agent} = initialize_registers()
    {:ok, content} = File.read(filename)
    run_program(agent, program_regex(content, agent))
  end

  def part2(filename) do
    IO.puts("NOT IMPLEMENTED YET")
  end
end
