defmodule Day21Test do

  use ExUnit.Case

  for{start_number, end_number, expected} <- [
    {"A","0", ["<", "A"]},
    {"0","2", ["^", "A"]},
    {"2","9", [">","^","^","A"]},
    {"9","A", ["v","v","v","A"]},
  ] do
    test "check punch_in_numbers #{start_number}, #{end_number}" do
      number_map = Utils.generate_map_from_split_str("789\n654\n321\n#0A")

      assert Day21.punch_in_numbers(number_map,unquote(start_number), unquote(end_number)) == unquote(expected)
    end
  end

end
