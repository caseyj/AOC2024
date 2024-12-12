defmodule Day3 do
  def scan_str_w_pat(str) do
    Regex.scan(~r/(mul\(\d+,\d+\))/, str)
  end

  def parse_mult_components(str) do
    if str != "do()" do
      capture = Regex.named_captures(~r/\((?<left>\d+),(?<right>\d+)\)/, str)
      Utils.to_int(Map.fetch!(capture, "left")) * Utils.to_int(Map.fetch!(capture, "right"))
    else
      0
    end
  end

  def get_sum_big_str(lst) do
    Enum.reduce(lst, 0, fn x, acc -> acc + parse_mult_components(hd(x)) end)
  end

  def scan_str_w_do_dont(str) do
    Regex.scan(~r/(mul\(\d+,\d+\)|do\(\)|don't\(\))/, str)
  end

  def until_dont(lst) do
    if lst == [] do
      []
    else
      split_list = Enum.split_while(lst, fn x -> hd(x) != "don't()" end)
      elem(split_list, 0) ++ until_do(elem(split_list, 1))
    end
  end

  def until_do(lst) do
    if lst == [] do
      []
    else
      until_dont(elem(Enum.split_while(lst, fn x -> hd(x) != "do()" end), 1))
    end
  end

  def part1(path) do
    {:ok, contents} = File.read(path)
    get_sum_big_str(scan_str_w_pat(contents))
  end

  def part2(path) do
    {:ok, contents} = File.read(path)
    data = until_dont(scan_str_w_do_dont(contents))
    get_sum_big_str(data)
  end
end
