defmodule Day9 do


  @doc """
  Ids are easily generated and re-incremented as strings
  """
  def id_increment(str) do
    "#{Utils.to_int(str)+1}"
  end

  def accumulate_periods(num) do
    if num == 0 do
      []
    else
      Enum.reduce(0..abs(num-1), [], fn _,acc -> acc++["."] end)
    end
  end

  def accumulate_ids(num, id) do
    Enum.reduce(0..num-1, [], fn _,acc -> acc++[id] end)
  end

  def accum_correct_value(num, id) do
    case id do
      x when rem(x,2) == 0 -> accumulate_ids(num,floor(id/2))
      _ -> accumulate_periods(num)
    end
  end

  def build_accum(numbers) do
    Enum.reduce(
      Enum.with_index(numbers),
      [],
      fn x,acc ->
        acc++accum_correct_value(
          Utils.to_int(elem(x, 0)), elem(x, 1))
      end)
  end

  def get_next_index_of_non_free_space(enum_w_index) do
    Enum.reduce_while(Enum.reverse(enum_w_index), 0, fn x, _ -> if elem(x,0)!="." do {:halt, elem(x,1)} else {:cont, 0} end end)
  end

  def swap(current_defrag, swap_val,swap_spot_left) do
    swap_v = elem(swap_val, 0)
    swap_spot_right = elem(swap_val,1)
    delete_original_spot = List.delete_at(current_defrag, swap_spot_left)
    insert_swap_value = List.insert_at(delete_original_spot, swap_spot_left, swap_v)
    delete_swap_spot = List.delete_at(insert_swap_value, swap_spot_right)
    List.insert_at(delete_swap_spot, swap_spot_right,".")
  end

  @spec swap_one_digit_at_a_time(list()) :: map()
  def swap_one_digit_at_a_time(accumulated_list) do
    converted_list = Enum.with_index(accumulated_list)
    Enum.reduce_while(0..length(converted_list)-1,
    %{
      :defrag=>accumulated_list,
      :seek=>get_next_index_of_non_free_space(converted_list)},
      fn indx, acc ->
      if indx >= Map.get(acc, :seek) do
        {:halt, acc}
      else
          current_defrag_as_tuple = List.to_tuple(Enum.with_index(Map.get(acc, :defrag)))
          val = elem(current_defrag_as_tuple, indx)

        if elem(val,0)=="." do
          acc = Map.put(acc, :defrag, swap(Map.get(acc, :defrag), elem(current_defrag_as_tuple, Map.get(acc, :seek)), indx))
          {:cont, Map.put(acc, :seek, get_next_index_of_non_free_space(Enum.with_index(Map.get(acc, :defrag))))}
        else
          {:cont, acc}
        end
      end

    end)
  end

  def block_sort(block1, block2) do
    elem(block1, 0) <= elem(block2,0)
  end

  def defrag_to_sum(map) do
    Enum.reduce(Enum.with_index(Map.get(map, :defrag)), 0, fn elm, acc ->
      if elem(elm,0) == "." do
        acc
      else
        acc+(elem(elm, 0)*elem(elm, 1))
      end
    end)
  end

  def block_builder(block_id, start_id, end_id) do
    {block_id, start_id, end_id, end_id - start_id}
  end

  def block_list_to_id_queue(block_list) do
    Enum.reduce(block_list, %{}, fn x, acc ->
      if elem(x,0) != "." do
        map = Utils.map_append_lists(acc, elem(x, 3), [x])
        Map.put(
          acc,
          elem(x, 3),
          Enum.sort(
            Map.get(map,elem(x, 3)),
            &(elem(&1, 0) >= elem(&2, 0))
        )
      )
      else
        acc
      end
    end)
  end



  def decompose_to_blocks(block_list) do
    block_list_w_enum = Enum.with_index(block_list)
    Enum.reduce(block_list_w_enum, [], fn block, acc ->
      if elem(block,1) > 0 do
        eol = List.last(acc)
        eol_index = length(acc) -1
        if elem(block,0) == elem(eol,0) do
          updated_val = block_builder(elem(eol,0), elem(eol,1), elem(block,1)+1)
          acc = List.delete_at(acc, eol_index)
          acc++[updated_val]
        else
          acc++[block_builder(elem(block,0), elem(block,1), elem(block,1)+1)]
      end
      else
        acc++[block_builder(elem(block,0), elem(block,1), elem(block,1)+1)]
      end
    end)
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    Day9.defrag_to_sum(Day9.swap_one_digit_at_a_time(
      Day9.build_accum(String.split(content, "", trim: true))
    ))
  end

  def part2(filename) do
    {:ok, _} = File.read(filename)
    IO.puts("NOT YET IMPLEMENTED")
  end

end
