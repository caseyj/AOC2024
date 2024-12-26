defmodule Day24 do


  def and_gate(val1, val2) do
    if val1+val2 == 2 do
      1
    else
      0
    end
  end

  def or_gate(val1, val2) do
    if val1+val2 == 0 do
      0
    else
      1
    end
  end

  def xor_gate(val1,val2) do
    if val1+val2 == 1 do
      1
    else
      0
    end
  end

  def operation(val1, val2, op) do
    case op do
      x when x == "AND" -> and_gate(val1, val2)
      x when x == "OR" -> or_gate(val1, val2)
      x when x == "XOR" -> xor_gate(val1, val2)
    end
  end

  def parse_assignment(line) do
    Regex.named_captures(~r/(?<left>[a-z|A-Z|0-9]{3})\W(?<op>AND|OR|XOR)\W(?<right>[a-z|A-Z|0-9]{3})\W->\W(?<assingnment>[a-z|A-Z|0-9]{3})/, line)
  end

  def parse_setting(line) do
    Regex.named_captures(~r/(?<pointer>[a-z|A-Z|0-9]{3}):\W(?<value>0|1)/, line)
  end

  def build_assignment_map(assignment_lines) do
    Enum.reduce(String.split(assignment_lines, "\n", trim: true), %{}, fn line, acc ->
      assignment = parse_assignment(line)
      assignment_details = {Map.get(assignment, "left"), Map.get(assignment, "right"), Map.get(assignment, "op")}
      Map.put(acc, Map.get(assignment, "assingnment"), assignment_details)
    end)
  end

  def build_settings(setting_lines) do
    Enum.reduce(String.split(setting_lines, "\n", trim: true), %{}, fn line, acc ->
      setting = parse_setting(line)
      Map.put(acc, Map.get(setting, "pointer"), Utils.to_int(Map.get(setting, "value")))
  end)
end



def run_operation(operation, assignments) do
  val1_ptr = Map.get(assignments,elem(operation,0))
  val2_ptr = Map.get(assignments, elem(operation,1))
  op = elem(operation, 2)
  operation(val1_ptr, val2_ptr, op)
end

def get_order_for_start(start_ptr, operations_list) do
  components = Map.get(operations_list,start_ptr)
  if components == nil do
    [start_ptr]
  else
    get_order_for_start(elem(components, 0), operations_list)++get_order_for_start(elem(components, 1), operations_list)++[start_ptr]
  end
end

def execute_orders(order, operations_map, assignments) do
  Enum.reduce(order, assignments, fn next_op, acc ->
    if Map.get(assignments, next_op) == nil do
      Map.put(acc, next_op,run_operation(Map.get(operations_map, next_op), acc))
    else
      acc
    end
  end)
end

def find_z_order(operations_map) do
  Enum.filter(Map.keys(operations_map), fn op -> String.starts_with?(op, "z") end)
  |> Enum.sort()
end

def find_zs(operations_map) do
  find_z_order(operations_map) |> Enum.reduce([], fn op, acc ->
    acc++[get_order_for_start(op, operations_map)]
  end)
end

def execute_all_zs(operations_map, assignments) do
  Enum.reduce(find_zs(operations_map), assignments, fn operation_set, acc ->
    execute_orders(operation_set, operations_map, acc)
  end)
end

def get_z_digits(operations_map, assignment_map) do
  Enum.reduce(find_z_order(operations_map), [], fn op, acc ->
    [Map.get(assignment_map, op)]++acc
  end)
end

def split_at_diffeen(str) do
  {assignments, operations} = List.to_tuple(String.split(str, "\n\n", trim: true))
  {build_settings(assignments), build_assignment_map(operations)}
end


def part1(filename) do
  {:ok, content} = File.read(filename)
  {assignments, operations} = split_at_diffeen(content)
  Enum.join(get_z_digits(operations,Day24.execute_all_zs(operations, assignments)), "")
end

def part2(_)do
  IO.puts("NOT YET IMPLEMENTED")
end

end
