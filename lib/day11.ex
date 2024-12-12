defmodule Day11 do
  @spec stone_split(binary()) :: list()
  def stone_split(stone_str) do
    split_val = div(String.length(stone_str), 2)
    Enum.map(Tuple.to_list(String.split_at(stone_str, split_val)), fn x -> Utils.to_int(x) end)
  end

  @spec stone_digits(binary()) :: boolean()
  def stone_digits(stone) do
    rem(String.length(stone), 2) == 0
  end

  @spec stone_response(integer()) :: list()
  def stone_response(stone_number) do
    if stone_number == 0 do
      [1]
    else
      stone_str = "#{stone_number}"

      if stone_digits(stone_str) do
        stone_split(stone_str)
      else
        [stone_number * 2024]
      end
    end
  end

  # def new_task_each_stone(stones, agent, incmap, supervisor, blinks) do
  #  Enum.map(stones, fn stone ->
  #    Task.Supervisor.async(supervisor, fn -> stone_line([stone], agent, incmap, supervisor, blinks-1)end)
  #  end)
  # end

  def stone_line(stone_line, agent, incmap, blinks) do
    if blinks != 0 do
      stone = stone_line
      memo_stone = KV.get(agent, stone)

      if memo_stone do
        # new_task_each_stone(memo_stone, agent, incmap, supervisor, blinks)
        if length(memo_stone) == 2 do
          tasks = Task.async(fn -> stone_line(hd(tl(memo_stone)), agent, incmap, blinks - 1) end)
          Task.await(tasks, :infinity) + stone_line(hd(memo_stone), agent, incmap, blinks - 1)
        else
          stone_line(hd(memo_stone), agent, incmap, blinks - 1)
        end
      else
        result = stone_response(stone)
        KV.put(agent, stone, result)
        # new_task_each_stone(memo_stone, agent, incmap, supervisor, blinks)

        if length(result) == 2 do
          tasks = Task.async(fn -> stone_line(hd(result), agent, incmap, blinks - 1) end)
          Task.await(tasks, :infinity) + stone_line(hd(tl(result)), agent, incmap, blinks - 1)
        else
          stone_line(hd(result), agent, incmap, blinks - 1)
        end
      end
    else
      1
    end
  end

  # def blink_n_times(memo,agent, supervisor, blinks) do
  # if blinks == 0 do
  # memo
  # else
  #  blink_n_times(stone_line(memo, agent, supervisor), agent, supervisor,blinks-1)
  # end
  # end

  def part1(filename) do
    part1(filename, 25)
  end

  def part1(filename, blink_count) do
    {:ok, content} = File.read(filename)
    {:ok, agent} = KV.start()
    {:ok, incrementor_map} = IncMap.start()

    # {:ok, supervisor} = Supervisor.start_link([
    #  {Task.Supervisor, name: MyApp.TaskSupervisor}
    # ], strategy: :one_for_one)

    strings_split =
      Enum.map(
        String.split(
          content,
          " ",
          trim: true
        ),
        fn x -> Utils.to_int(x) end
      )

    tasks =
      Enum.map(strings_split, fn x ->
        Task.async(fn ->
          stone_line(
            x,
            agent,
            incrementor_map,
            blink_count
          )
        end)
      end)

    Enum.sum(Task.await_many(tasks, :infinity))

    # Task.await_many(tasks,:infinity)
    # IncMap.map_value_sum(incrementor_map)
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)
    part1(filename, 75)
  end
end
