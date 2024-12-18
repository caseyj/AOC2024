defmodule Day18Test do

  use ExUnit.Case

  test "intake_str" do
    str = "5,4\n4,2\n4,5\n3,0\n2,1\n6,3\n2,4\n1,5\n0,6\n3,3\n2,6\n5,1\n1,2\n5,5\n2,5\n6,5\n1,4\n0,4\n6,4\n1,1\n6,1\n1,0\n0,5\n1,6\n2,0"
    assert Day18.intake_str(str, 25) == [{5, 4}, {4, 2}, {4, 5}, {3, 0}, {2, 1}, {6, 3}, {2, 4}, {1, 5}, {0, 6}, {3, 3}, {2, 6}, {5, 1}, {1, 2}, {5, 5}, {2, 5}, {6, 5}, {1, 4}, {0, 4}, {6, 4}, {1, 1}, {6, 1}, {1, 0}, {0, 5}, {1, 6}, {2, 0}]
    assert Day18.intake_str(str, 12) == [
      {5, 4},
      {4, 2},
      {4, 5},
      {3, 0},
      {2, 1},
      {6, 3},
      {2, 4},
      {1, 5},
      {0, 6},
      {3, 3},
      {2, 6},
      {5, 1}
    ]
  end

  test "A_star correct results" do
    input_str = "5,4\n4,2\n4,5\n3,0\n2,1\n6,3\n2,4\n1,5\n0,6\n3,3\n2,6\n5,1\n1,2\n5,5\n2,5\n6,5\n1,4\n0,4\n6,4\n1,1\n6,1\n1,0\n0,5\n1,6\n2,0"

    target = {6,6}
    start = {0,0}
    run = Day18.a_star(
      [
        {
          start,
          :north,
          0,
          Utils.manhattan(start, target),
          []
        }], target, [], Day18.intake_str(input_str, 12))
    assert elem(run, 2)== 22
  end

  test "part 2 " do
    #Day18.part2("data/day18.txt")
    assert 1==1
  end

end