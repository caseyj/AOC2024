defmodule Day23 do

  def alternate(pair) do
    {left, right} = List.to_tuple(pair)
    [right, left]
  end

  def get_pairs(str) do
    Enum.reduce(String.split(str, "\n", trim: true), [], fn line, acc ->
      acc++[String.split(line, "-", trim: true)]
    end)

  end

  def make_map(input_str) do
    Enum.reduce(String.split(input_str, "\n", trim: true), %{}, fn line, acc ->
      {left, right} = List.to_tuple(String.split(line, "-", trim: true))
      Utils.map_append_lists(Utils.map_append_lists(acc, left, [right]), right, [left])
    end)
  end

  def make_arc_pair(left, right) do
    ["#{left}-#{right}", "#{right}-#{left}"]
  end

  def make_arcs(first, second, third) do
    basic = make_arc_pair(first, second)
    three_two = make_arc_pair(second, third)
    full_arc = make_arc_pair(basic, third)
    third_full_arc = make_arc_pair(three_two, first)
    {basic++three_two, full_arc++third_full_arc}
  end

  def get_neighbors(input, map) do
    Map.get(map, input, [])
  end

  def get_common_neighbors(input1, input2, map) do
    Enum.filter(
      get_neighbors(input1, map),
      fn x -> Enum.member?(
        get_neighbors(input2, map),
        x)
    end)
  end

  def find_pairs(map_keys) do
    for x <- map_keys, y <- map_keys, x != y, do: [x,y]
  end

  @doc """
  Produces a map from value=>number of times detected in a list
  """
  def count_list_elements(list) do
    Enum.reduce(list, %{}, fn element, acc ->
      Map.put(acc, element, Map.get(acc, element, 0)+1)
    end)
  end

  @doc """
  Checks that two lists are "equal". Equality is defined as both lists are the same length and contain the same characters.
  """
  def equal_lists(list_1, list_2) do
    list_lengths = length(list_1) == length(list_2)
    element_counts_equal = count_list_elements(list_1) == count_list_elements(list_2)
    list_lengths == true and element_counts_equal == true
  end


  @doc """
  Determines if a provided list is in a list of lists
  """
  def element_not_in_list_of_lists(element, list_of_lists) do
    Enum.all?(list_of_lists, fn list-> equal_lists(element, list) == false end)
  end

  @doc """
  Iterates over all of the neighbor pairs to identify groups of triplets
  """
  def build_triplets(str) do
    map = make_map(str)
    pairs = get_pairs(str)
    Enum.reduce(pairs, %{:seen=>[], :accepted=>[]}, fn [left, right], acc ->
      [alternate_l, alternate_r] = [[left,right],[right,left]]
      if Enum.member?(Map.get(acc, :seen), alternate_l) == false and Enum.member?(Map.get(acc, :seen), alternate_r) == false do
        seen_updated = Utils.map_append_lists(acc, :seen, [alternate_l, alternate_r])
        common_neighbors = get_common_neighbors(left, right, map)
        Enum.reduce(common_neighbors, seen_updated,
          fn neighbor, acc2 ->
            new_arc = [left, right, neighbor]
            if element_not_in_list_of_lists(new_arc, Map.get(acc2, :accepted)) do
              Utils.map_append_lists(acc2, :accepted, [new_arc])
            else
              acc2
            end
          end)
      else
        acc
      end
    end)
  end

  @doc """
  only used for testing
  """
  def split_to_triplets(str) do
    Enum.reduce(String.split(str, "\n", trim: true), [] ,fn line, acc->
      acc++[String.split(line, ",", trim: true)]
    end)
  end

  def check_elem_for_t(str) do
    Regex.run(~r/t[a-zA-Z]/, str) != nil
  end

  def atleast_1_t(triplet) do
    Enum.any?(triplet, fn un -> check_elem_for_t(un) end)
  end

  def only_lists_with_ts(list_of_triplets) do
    Enum.reduce(list_of_triplets, [], fn triplet, acc ->
      if atleast_1_t(triplet) do
        acc++[triplet]
      else
        acc
      end
    end)
  end

  def flip_lists_if_left_larger(list_1, list_2) do
    if length(list_1) > length(list_2) do
      {list_2, list_1}
    else
      {list_1, list_2}
    end
  end

  def list_intersection(list_1, list_2) do
    {left_list, right_list} = flip_lists_if_left_larger(list_1, list_2)
    Enum.reduce(left_list, [], fn item, acc->
      if Enum.member?(right_list, item) do
        acc++[item]
      else
        acc
      end
    end)
  end

  def bron_kerbosh(cliques, verts, exclusion, map) do
    if length(verts) == 0 and length(exclusion) == 0 do
      cliques
    else
      vert = hd(verts)
      vert_neighbors = get_neighbors(vert, map)
      vert_intersect = list_intersection(vert_neighbors, verts)
      exclusion_intersect = list_intersection(vert_neighbors, exclusion)
      brk_input = {cliques++vert, vert_intersect, exclusion_intersect}
    end
  end

  def part1(filename) do
    {:ok, content} = File.read(filename)
    length(only_lists_with_ts(Map.get(build_triplets(content), :accepted)))
  end

  def part2(_) do
    IO.puts("NOT IMPLEMENTED YET")
  end

end
