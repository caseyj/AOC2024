defmodule Day22Test do

  use ExUnit.Case

  test "Mix" do
    assert Day22.mix(42,15) == 37
    assert Day22.mix(15,42) == 37
  end

  test "Prune" do
    assert Day22.prune(100000000) == 16113920
  end


  for {start, expected} <- [
    {123, 15887950},
    {15887950,16495136},
    {16495136,527345},
    {527345,704524},
    {704524,1553684},
  {1553684,12683156},
  {12683156, 11100544},
  {11100544, 12249484},
  {12249484, 7753432},
  {7753432, 5908254}
  ] do
    test "Check progression is correct #{start}, #{expected}" do
      assert Day22.all3(unquote(start)) == unquote(expected)
    end
  end

  for {start, depth, expected} <- [
    {123,10,5908254},
    {1, 2000, 8685429},
    {10, 2000, 4700978},
    {100,2000, 15273692},
    {2024, 2000, 8667524}
  ] do
    test "n_numbers #{start}, #{depth}" do
      assert Day22.n_numbers(unquote(start), unquote(depth)) == unquote(expected)
    end
  end

  test "day 22 pt 1" do
    assert Day22.part1("data/day22_sample.txt") == 37327623
  end

end
