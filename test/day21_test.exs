defmodule Day21Test do

  use ExUnit.Case

  for {direction, expected} <- [] do
    test "direction to pad instructions #{direction}"
  end

  for{start_number, end_number, size_x, size_y, number_map_input,expected} <- [
    {"A","0", 3,4, "789\n654\n321\n#0A" , [["<", "A"]]},
    {"0","2", 3,4, "789\n654\n321\n#0A", [["^", "A"]]},
    {"2","9", 3,4, "789\n654\n321\n#0A", [["^","^",">","A"]]},
    {"9","A", 3,4, "789\n654\n321\n#0A", [["v","v","v","A"]]},
    {"A","<", 3,2, "#^A\n<v>", [["v","<","<","A"],["<", "v", "<", "A"]]},
    {"<","A", 3,2, "#^A\n<v>", [[">",">","^","A"],[">", "^", ">", "A"]]},
    {"A","^", 3,2, "#^A\n<v>", [["<","A"]]},
    {"^","A", 3,2, "#^A\n<v>", [[">","A"]]},
    {"A",">", 3,2, "#^A\n<v>", [["v","A"]]},
    {">","A", 3,2, "#^A\n<v>", [["^","A"]]},
    {"A","v", 3,2, "#^A\n<v>", [["<","v","A"],["v","<","A"], ]},
    {"v","A", 3,2, "#^A\n<v>", [[">","^","A"],["^",">","A"], ]},
  ] do
    test "check punch_in_numbers #{start_number}, #{end_number}" do
      number_map = Utils.generate_map_from_split_str(unquote(number_map_input))
      direction_pad = Utils.generate_map_from_split_str("#^A\n<v>")
      assert Enum.member?(unquote(expected),Day21.punch_in_numbers(number_map,unquote(start_number), unquote(end_number), unquote(size_x), unquote(size_y), &Day21.find_distance_for_move/3,direction_pad))
    end
  end

  for {instructions_list,expected} <- [
    {["^",">"], 5},
    {["<","A","^","A",">","^","^","A","v","v","v","A"], 28},
    {["v", "<", "<", "A", ">", ">", "^", "A", "<", "A", ">", "A", "v", "A", "<", "^", "A", "A", ">", "A", "<", "v", "A", "A", "A", ">", "^", "A"], 1, 68},
  ] do
    test "Check instructions_to_instructions #{expected}" do
      map = Utils.generate_map_from_split_str( "#^A\n<v>")
      assert length(Day21.instructions_to_instructions(unquote(instructions_list), map, 1)) == unquote(expected)
    end
  end

  test "exacly 1 case" do
    assert Enum.join(Day21.get_full_robot_list("029A"),"") == "<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A"
  end

  test "Check instructions_to_instructions instructions_to_instructions" do
    map = Utils.generate_map_from_split_str( "#^A\n<v>")
    assert length(Day21.instructions_to_instructions(["<","A","^","A",">","^","^","A","v","v","v","A"], map, 2)) == 68
  end


  for {input_str, expected_size} <- [
   {"029A" , 68},
   {"980A", 60},
   {"179A", 68},
   {"456A", 64},
   {"379A", 64},
  ] do
    test "get_full_robot_list #{input_str}" do
      robot_list = Day21.get_full_robot_list(unquote(input_str))
      assert length(robot_list) == unquote(expected_size)
    end
  end



end
