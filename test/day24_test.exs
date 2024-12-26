defmodule Day24Test do

  use ExUnit.Case

  test "build_settings" do
    assert Day24.build_settings("x00: 1\nx01: 1\nx02: 1\ny00: 0\ny01: 1\ny02: 0") == %{
      "x00"=>1, "x01"=>1, "x02"=>1, "y00"=>0, "y01"=>1, "y02"=>0}
  end

  test "build_assignment_map" do
    assert Day24.build_assignment_map("x00 AND y00 -> z00\nx01 XOR y01 -> z01\nx02 OR y02 -> z02") == %{
      "z00"=>{"x00", "y00", "AND"},
      "z01"=>{"x01", "y01", "XOR"},
      "z02"=>{"x02", "y02", "OR"}
    }
  end

  test "get_order_for_start" do
    data = %{
      "z00"=>{"x00", "y00", "AND"},
      "z01"=>{"x01", "y01", "XOR"},
      "z02"=>{"x02", "y02", "OR"},
      "z04"=>{"z01", "z02", "OR"}
    }
    assert Day24.get_order_for_start("z00", data) == ["x00", "y00", "z00"]
    assert Day24.get_order_for_start("z04", data) == ["x01", "y01", "z01", "x02" ,"y02","z02","z04"]
  end

  test "execute_orders" do
    operations_map = %{
      "z00"=>{"x00", "y00", "AND"},
      "z01"=>{"x01", "y01", "XOR"},
      "z02"=>{"x02", "y02", "OR"},
      "z04"=>{"z01", "z02", "OR"}
    }
    assignments_map = %{
      "x00"=>1, "x01"=>1, "x02"=>1, "y00"=>0, "y01"=>1, "y02"=>0}
    assert Day24.execute_orders(["x01"], operations_map, assignments_map) == assignments_map
    assert Day24.execute_orders(["x02"], operations_map, assignments_map) == assignments_map
    assert Day24.execute_orders(Day24.get_order_for_start("z02", operations_map), operations_map, assignments_map) == Map.put(assignments_map, "z02", 1)
    assert Day24.execute_orders(Day24.get_order_for_start("z04", operations_map), operations_map, assignments_map) == Map.put(Map.put(Map.put(assignments_map, "z04", 1), "z02", 1), "z01", 0)
  end

  test "find_zs" do
    assert Day24.find_zs(%{
      "z00"=>{"x00", "y00", "AND"},
      "z01"=>{"x01", "y01", "XOR"},
      "z02"=>{"x02", "y02", "OR"},
      "z04"=>{"z01", "z02", "OR"}
    }) == [["x00","y00", "z00"], ["x01","y01", "z01"], ["x02","y02", "z02"], ["x01","y01", "z01", "x02","y02", "z02", "z04"]]
  end

  test "execute_all_zs" do
    operations_map = %{
      "z00"=>{"x00", "y00", "AND"},
      "z01"=>{"x01", "y01", "XOR"},
      "z02"=>{"x02", "y02", "OR"},
      "z04"=>{"z01", "z02", "OR"}
    }
    assignments_map = %{
      "x00"=>1, "x01"=>1, "x02"=>1, "y00"=>0, "y01"=>1, "y02"=>0}
    assert Day24.execute_all_zs(operations_map, assignments_map) == Map.put(Map.put(Map.put(Map.put(assignments_map, "z04", 1), "z02", 1), "z01", 0), "z00", 0)
  end

  test "get_z_digits" do
    operations_map = %{
      "z00"=>{"x00", "y00", "AND"},
      "z01"=>{"x01", "y01", "XOR"},
      "z02"=>{"x02", "y02", "OR"},
      "z04"=>{"z01", "z02", "OR"}
    }
    assignments_map = %{
      "x00"=>1, "x01"=>1, "x02"=>1, "y00"=>0, "y01"=>1, "y02"=>0}
    am = Day24.execute_all_zs(operations_map, assignments_map)
    assert Day24.get_z_digits(operations_map, am) == [0,0,1,1]
  end

  test "Part 1 " do
    assert Day24.part1("data/day24_sample.txt") == "0011111101000"
  end



end
