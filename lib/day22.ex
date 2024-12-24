defmodule Day22 do

  def mix(secret_number, mixer) do
    Bitwise.bxor(secret_number, mixer)
  end

  def prune(secret_number) do
    rem(secret_number,16777216)
  end

  def step1(secret_number) do
    left = secret_number*64
    secret = mix(secret_number, left)
    prune(secret)
  end

  def step2(secret_number) do
    divis = floor(div(secret_number, 32))
    secret = mix(divis, secret_number)
    prune(secret)
  end

  def step3(secret_number) do
    left = secret_number*2048
    secret = mix(secret_number, left)
    prune(secret)
  end

  def all3(secret_number) do
    secret1 = step1(secret_number)
    secret2 = step2(secret1)
    step3(secret2)
  end

  def n_numbers(secret_number, depth) do
    if depth == 1 do
      all3(secret_number)
    else
      n_numbers(all3(secret_number), depth-1)
    end
  end


  def part1(filename) do
    {:ok, content} = File.read(filename)
    tasks =
      Enum.map(String.split(content, "\n", trim: true), fn x ->
        Task.async(fn -> n_numbers(Utils.to_int(x), 2000) end)end)

    Enum.sum(Task.await_many(tasks, :infinity))
  end

  def part2(_) do
    IO.puts("NOT IMPLEMENTED YET")
  end

end
