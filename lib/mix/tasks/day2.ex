defmodule Mix.Tasks.Day2 do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "runs day 1 with a given input file"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    filename = Enum.join(args, " ")
    IO.puts(Day2.part1(filename))
    IO.puts(Day2.part2(filename))
  end
end
