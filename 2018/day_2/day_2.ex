defmodule AOC.TwentyEighteen.Day2 do
  def part_1() do
    %{"3" => total_3, "2" => total_2} =
      AOC.read_input("2018/day_2")
      |> Enum.reduce(%{"2" => 0, "3" => 0}, fn id, acc ->
        counts =
          String.split(id, "", trim: true)
          |> Enum.reduce(%{}, &Map.update(&2, &1, 1, fn val -> val + 1 end))
          |> Enum.reduce(%{"2" => 0, "3" => 0}, fn
            {_, 2}, count ->
              Map.update!(count, "2", fn _ -> 1 end)

            {_, 3}, count ->
              Map.update!(count, "3", fn _ -> 1 end)

            _, count ->
              count
          end)

        %{acc | "2" => acc["2"] + counts["2"], "3" => acc["3"] + counts["3"]}
      end)

    total_2 * total_3
  end

  def part_2() do
    AOC.read_input("2018/day_2")
    |> traverse_list()
  end

  def traverse_list([head | tail]) do
    traverse_list(head, tail, tail)
  end

  def traverse_list(_, [], [head | tail]) do
    traverse_list(head, tail, tail)
  end

  def traverse_list(compare, [current | tail] = remaining, rest_list)
      when length(remaining) > 0 do
    case compare_strings(compare, current) do
      :notfound ->
        traverse_list(compare, tail, rest_list)

      common_chars ->
        common_chars
    end
  end

  def compare_strings(s1, s2) do
    s1 = String.split(s1, "", trim: true)
    s2 = String.split(s2, "", trim: true)
    zipped = Enum.zip(s1, s2)

    case Enum.reduce(zipped, %{misses: 0, common: ""}, fn
           {s, s}, acc ->
             %{acc | common: acc.common <> s}

           _, acc ->
             %{acc | misses: acc.misses + 1}
         end) do
      %{misses: 1, common: common} ->
        common

      _ ->
        :notfound
    end
  end
end
