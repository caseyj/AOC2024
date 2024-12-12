defmodule Mix.Tasks.DayRun do
  @moduledoc "Printed when the user requests `mix help echo`"
  @shortdoc "runs day 1 with a given input file"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    args_n = List.to_tuple(args)
    module_name = "Elixir.#{elem(args_n, 0)}"
    module = String.to_existing_atom(module_name)
    filename = "data/#{String.downcase(elem(args_n, 0))}.txt"
    IO.puts(module.part1(filename))
    IO.puts(module.part2(filename))
  end
end
