defmodule Day5Test do
  use ExUnit.Case

  test "Adds rules to map from initial string." do
    assert Day5.parse_to_rule_map("76|78\n76|79\n79|80") == %{
             "78" => ["76"],
             "79" => ["76"],
             "80" => ["79"]
           }
  end

  for {number, expected} <- [
        {"75", []},
        {"47", ["75"]},
        {"61", ["47", "75"]},
        {"53", ["47", "75", "61"]},
        {"29", ["75", "53", "61", "47"]}
      ] do
    test "Check rule #{number} gets the correct list of prereqs #{expected}" do
      sample_rules =
        "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13\n"

      assert Day5.get_pre_reqs_for_number(
               unquote(number),
               Day5.parse_to_rule_map(sample_rules),
               ["75", "47", "61", "53", "29"]
             ) == unquote(expected)
    end
  end

  for {number, visited, expected} <- [
        {"75", [], true},
        {"47", ["75"], true},
        {"61", ["47", "75"], true},
        {"53", ["47", "75", "61"], true},
        {"47", [], false},
        {"61", ["75"], false},
        {"53", ["47"], false},
        {"29", ["75", "53", "61", "47", true]}
      ] do
    test "Check visited list for #{number} satisfies the rules with an expected result of #{expected}" do
      sample_rules =
        "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13\n"

      assert Day5.check_visited(
               unquote(number),
               unquote(visited),
               Day5.parse_to_rule_map(sample_rules),
               ["75", "47", "61", "53", "29"]
             ) == unquote(expected)
    end
  end

  for {update_instructions, expected} <- [
        {"75,47,61,53,29", true},
        {"97,61,53,29,13", true},
        {"75,29,13", true},
        {"75,97,47,61,53", false},
        {"61,13,29", false},
        {"97,13,75,29,47", false}
      ] do
    test "Check that the instructions #{update_instructions} have a correct detection of #{expected}" do
      sample_rules =
        "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13\n"

      assert Day5.check_update_list_is_valid(
               String.split(unquote(update_instructions), ",", trim: true),
               Day5.parse_to_rule_map(sample_rules)
             ) == unquote(expected)
    end
  end

  for {input_list, expected} <- [
        {"75,47,61,53,29", "61"},
        {"97,61,53,29,13", "53"},
        {"75,29,13", "29"}
      ] do
    test "Check that the middle number #{expected} is correctly found in the list #{input_list}" do
      assert Day5.middle(String.split(unquote(input_list), ",", trim: true)) == unquote(expected)
    end
  end

  test "Get correct traversals sum" do
    rules_map =
      Day5.parse_to_rule_map(
        "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13\n"
      )

    traversals =
      Day5.parse_traversal(
        "75,47,61,53,29\n97,61,53,29,13\n75,29,13\n75,97,47,61,53\n61,13,29\n97,13,75,29,47"
      )

    assert Day5.sum_correct_traversals(traversals, rules_map, "correct") == 143
  end

  for {input_list, expected} <- [
        {["75", "97", "47", "61", "53"], ["97", "75", "47", "61", "53"]},
        {["61", "13", "29"], ["61", "29", "13"]},
        {["97", "13", "75", "29", "47"], ["97", "75", "47", "29", "13"]}
      ] do
    test "Get corrected traversals for input #{input_list}" do
      rules_map =
        Day5.parse_to_rule_map(
          "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13\n"
        )

      assert Day5.get_corrected_traversal(
               unquote(input_list),
               [],
               rules_map,
               unquote(input_list)
             ) == unquote(expected)
    end
  end

  test "Check File IO for Day 5" do
    assert Day5.part1("data/day5_sample.txt") == 143
    assert Day5.part2("data/day5_sample.txt") == 123
  end
end
