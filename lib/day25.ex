defmodule Day25 do


  def detect_key_or_lock(str) do
    if String.starts_with?(str, "#") do
      :lock
    else
      :key
    end
  end

  def get_row_score(line) do
    Enum.reduce(String.split(line, "", trim: true), [], fn elm, acc ->
      if elm=="#" do
        acc++[1]
      else
        acc++[0]
      end
    end)
  end

  def sum_lists(list_1, list_2) do
    Enum.reduce(Enum.zip(list_1, list_2), [], fn summables, acc ->
      acc++[Tuple.sum(summables)]
    end)
  end

  def lists_overlap(lock, key) do
    Enum.all?(sum_lists(lock, key), fn pair -> pair<6 end)
  end

  def get_codes_for_board(str) do
    Enum.reduce(String.split(str, "\n", trim: true), [-1,-1,-1,-1,-1], fn line, acc ->
      sum_lists(acc, get_row_score(line))
    end)
  end

  def parse_locks_and_keys(lines) do
    lock_and_key = Enum.reduce(String.split(lines, "\n\n", trim: true), %{:lock=>[], :key=>[]}, fn board, acc ->
      if detect_key_or_lock(board) == :lock do
        Utils.map_append_lists(acc, :lock, [get_codes_for_board(board)])
      else
        Utils.map_append_lists(acc, :key, [get_codes_for_board(board)])
      end
    end)
    %{:lock=>List.to_tuple(Map.get(lock_and_key, :lock)), :key=>List.to_tuple(Map.get(lock_and_key, :key))}
  end

  def pair_lock_key(lock_key_map) do
    lock_length = tuple_size(Map.get(lock_key_map, :lock))-1
    key_length = tuple_size(Map.get(lock_key_map, :key))-1
    for x <- Enum.into(0..lock_length, []), y <- Enum.into(0..key_length, []), do: [x, y]
  end

  def count_pairs(lock_key_map) do
    pairs = pair_lock_key(lock_key_map)
    Enum.reduce(pairs, 0, fn [lock, key], acc ->
      lock_row = elem(Map.get(lock_key_map, :lock), lock)
      key_row = elem(Map.get(lock_key_map, :key), key)
      if lists_overlap(lock_row, key_row) do
        acc+1
      else
        acc
      end
    end)
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    Day25.count_pairs(Day25.parse_locks_and_keys(content))
  end

  def part2(_) do
    #{:ok, content} = File.read(filename)
    #Day25.count_pairs(Day25.parse_locks_and_keys(content))
    IO.puts("NOT YET IMPLEMENTED")
  end

end
