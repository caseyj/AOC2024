defmodule Day5 do

  def add_to_rule(str, map) do
    rule = String.split(str, "|", trim: true)
    rule_number = List.first(rule)
    rule_pre_req = List.last(rule)
    if Map.get(map, rule_pre_req) == nil do
      Map.put(map, rule_pre_req, [rule_number])
    else
      Map.update!(map, rule_pre_req, fn x -> x++[rule_number]  end)
    end

  end

  @doc """
  Designs a map of NUMBER=>[REQUIRED_PREREQS..]
  """
  def parse_to_rule_map(strs) do
      Enum.reduce(String.split(strs, "\n", trim: true), %{}, fn str, acc -> add_to_rule(str, acc)  end)
  end

  @doc """
  Builds a list of lists, where the individual element lists are composed of numbers in a row
  Example: [["76","78"]]
  """
  def parse_traversal(strs) do
    Enum.map(String.split(strs, "\n", trim: true), fn x -> String.split(x, ",", trim: true)end)
  end

  @doc """
  Gives the list of numbers that both appear in the update order AND are prerequisites to be visited before the current number
  """
  def get_pre_reqs_for_number(number, rules_map, traversal_list) do
    Enum.reduce(Map.get(rules_map, number,[]),
      [],
      fn pre_req, acc ->
        if Enum.member?(traversal_list, pre_req) do
          acc++[pre_req]
        else
          acc
        end
      end
    )
  end

  @doc """
  Gets each unvisited str item in a traversal
  """
  def find_unvisited(current_number, visited_list, rules_map, traversal_list) do
    Enum.reduce(
      get_pre_reqs_for_number(current_number, rules_map, traversal_list),
      [],
      fn pre_req, acc ->
        if Enum.member?(visited_list, pre_req) == false do
          acc++[pre_req]
        else
          acc
        end
      end)
  end

  @doc """
  For a given number, this gives a true/false that all prerequisites have been previously seen in the list
  """
  def check_visited(current_number, visited_list, rules_map, traversal_list) do
    unvisited = find_unvisited(current_number, visited_list, rules_map, traversal_list)
    if unvisited do
      Enum.count(unvisited) == 0
    else
      true
    end
  end

  def reduce_unvisited(unvisited, collected_path) do
    Enum.reduce(unvisited,[],fn x, acc ->
      if Enum.member?(collected_path, x) do
        acc
      else
        acc++[x]
      end
    end)
  end

  def next(list) do
    if list == nil do
      []
    else
      tl(list)
    end
  end

  @doc """
  From a given traversal list, identifies the correct order that a list should be in
  """
  def get_corrected_traversal(traversal, collector, rules_map, traverse_list) do
    if is_nil(traversal) do
      collector
    else
      if length(traversal) == 1 do
        if Enum.member?(collector,hd(traversal))==false do
          collector++traversal
        else
          collector
        end
      else
        next_item = hd(traversal)
        if Enum.member?(collector,next_item) do
          get_corrected_traversal(next(traversal), collector, rules_map, traverse_list)
        else
          unvisited = find_unvisited(next_item, collector, rules_map, traverse_list)
          if unvisited !=[] do
            reduced_unvisited =reduce_unvisited(unvisited, collector)
            collected = get_corrected_traversal(reduced_unvisited, collector, rules_map, traverse_list)
            if Enum.member?(collected, next_item) == false do
              nxt = next(traversal)
              get_corrected_traversal(nxt, collected++[next_item], rules_map, traverse_list)
            else
              nxt = next(traversal)
              get_corrected_traversal(nxt, collected, rules_map, traverse_list)
            end
          else
            get_corrected_traversal(next(traversal), collector++[next_item], rules_map, traverse_list)
          end
        end
      end
    end
  end

  @doc """
  Given a traversal list, detect if it is in the correct traversal order.
  """
  def check_update_list_is_valid(traversal_list, rules_map) do
    Enum.all?(
      Enum.with_index(traversal_list),
      fn elm -> check_visited(
        elem(elm,0),
        Enum.slice(traversal_list, 0..elem(elm, 1)),
        rules_map,
        traversal_list
      )end
    )
  end

  @doc """
  Gets the middle indexed item in a list
  """
  def middle(list) do
    Enum.at(list ,list |> length() |> div(2))
  end


  def split_correct_and_incorrect_traversals(all_traversals, rules_map) do
    Enum.reduce(all_traversals,
     %{"correct"=>[], "incorrect"=>[]},
    fn traversal, acc ->
      if check_update_list_is_valid(traversal, rules_map) do
        Map.put(acc, "correct", Map.get(acc, "correct")++[traversal])
      else
        Map.put(acc, "incorrect", Map.get(acc, "incorrect")++[get_corrected_traversal(traversal, [], rules_map, traversal)])
      end
    end)
  end

  def sum_middle(lists) do
    Enum.reduce(lists, 0, fn x,acc -> acc+Utils.to_int(middle(x)) end)
  end

  @doc """
  Gets the sum of the middle number for each traversal instruction that is correct.
  """
  def sum_correct_traversals(all_traversals, rules_map, part)do
    sum_middle(
      Map.get(
        split_correct_and_incorrect_traversals(
          all_traversals,
          rules_map),
        part))
  end


  def part1(filename) do
    {:ok, contents} = File.read(filename)
    input_split = String.split(contents, "\n\n")
    sum_correct_traversals(parse_traversal(List.last(input_split)), parse_to_rule_map(List.first(input_split)),"correct")
  end

  def part2(filename) do
    {:ok, contents} = File.read(filename)
    input_split = String.split(contents, "\n\n")
    sum_correct_traversals(parse_traversal(List.last(input_split)), parse_to_rule_map(List.first(input_split)), "incorrect")
  end


end
