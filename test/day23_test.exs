defmodule Day23Test do

  use ExUnit.Case

  test "Create map of lnks" do
    assert Day23.make_map("kh-tc\nqp-kh") == %{"kh"=>["tc", "qp"], "tc"=> ["kh"], "qp"=>["kh"]}
  end

  for {left, right, expected} <- [
    {"qp", "rt", ["qp-rt","rt-qp"]},
    {"qp-tc", "rt", ["qp-tc-rt","rt-qp-tc"]},
  ] do
    test "Make arc pair #{left}, #{right}, #{expected}" do
      assert Day23.make_arc_pair(unquote(left), unquote(right)) == unquote(expected)
    end
  end

  test "get_common_neighbors" do
    map = Day23.make_map("qw-tq\nwe-re\ntq-yp\nyp-qw")
    assert Day23.get_common_neighbors("qw", "tq", map) == ["yp"]
    assert Day23.get_common_neighbors("qw", "re", map) == []
    assert Day23.get_common_neighbors("we", "re", map) == []
  end

  test "find_pairs" do
    detected_pairs = Day23.find_pairs(["qt","tc","lm"])
    assert Enum.all?([["qt","tc"],["qt","lm"], ["tc", "lm"]], fn x -> Enum.member?(detected_pairs, x)  end)
  end

  test "Count list elements" do
    assert Day23.count_list_elements(["1","1","3","4","4","4"]) == %{"1"=>2, "3"=>1, "4"=>3}
  end

  test "equal_lists" do
    assert Day23.equal_lists([1,2,3], [1,2,3]) == true
    assert Day23.equal_lists([1,2,3], []) == false
    assert Day23.equal_lists([1,2,3], [4,5,6]) == false
    assert Day23.equal_lists([1,2,3], [1,5,6]) == false
  end

  test "element_not_in_list_of_lists" do
    assert Day23.element_not_in_list_of_lists([1,2,3], []) == true
    assert Day23.element_not_in_list_of_lists([1,2,3], [[4,5,6]]) == true
    assert Day23.element_not_in_list_of_lists([1,2,3], [[4,5,6],[7,8,9],[0,9,5]]) == true
    assert Day23.element_not_in_list_of_lists([1,2,3], [[4,5,6],[1,2,3],[0,9,5]]) == false
    assert Day23.element_not_in_list_of_lists([1,2,3], [[1,2,3]]) == false
  end

  test "split_to_triplets" do
    assert Day23.split_to_triplets("aq,cg,yn\naq,vc,wq") == [["aq","cg","yn"],["aq","vc","wq"]]
  end

  test "check build_triplets" do
    {:ok, map_content} = File.read("data/day23_sample.txt")
    {:ok, answer_content} = File.read("data/day23_sample_answers.txt")
    triplets_predicted = Map.get(Day23.build_triplets(map_content), :accepted)
    answers = Day23.split_to_triplets(answer_content)
    assert length(triplets_predicted) == length(answers)
    Enum.map(triplets_predicted, fn line ->
      #IO.puts(line)
      assert Day23.element_not_in_list_of_lists(line, answers) == false
    end)

  end

  test "check_elem_for_t" do
    assert Day23.check_elem_for_t("tq") == true
    assert Day23.check_elem_for_t("aq") == false
    assert Day23.check_elem_for_t("qt") == false
  end

  test "only_lists_with_ts" do
    {:ok, map_content} = File.read("data/day23_sample.txt")
    triplets_predicted = Map.get(Day23.build_triplets(map_content), :accepted )
    assert length(Day23.only_lists_with_ts(triplets_predicted)) == 7
  end

end
