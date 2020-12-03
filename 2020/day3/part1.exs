defmodule Day1 do
  defp check_tree(l, x) do
    case Enum.at(l, x) do
      "#" -> true
      "." -> false
      # If we get back nil, it means the line needs to be extended.
      #
      # Since the pattern extends infinitely to the right, we can just
      # duplicate the list with itself.
      nil -> check_tree(l ++ l, x)
    end
  end

  def part1 do
    File.read!("./day3.txt")
    |> String.split("\n", trim: true)
    |> Enum.reduce({0, 0}, fn l, {x, trees} ->
      line = String.split(l, "", trim: true)

      if check_tree(line, x) do
        {x + 3, trees + 1}
      else
        {x + 3, trees}
      end
    end)
  end
end


# |> Enum.reduce({%{}, 0}, fn l, {lines, i} ->
#  {trees, _} =
#    String.split(l, "", trim: true)
#    |> Enum.reduce({[], 0}, fn
#      "#", {trees, index} -> {[index | trees], index + 1}
#      ".", {trees, index} -> {trees, index + 1}
#    end)
#
#  min = List.first(trees)
#  max = List.last(trees)
#
#  # Stores {min, max, tree_positions} with the key being the y value on the map
#  # %{0 => {25, 3, [3, 9, 17, 18, 25]}
#  {Map.put(lines, i, {min, max, Enum.reverse(trees)}), i + 1}
# end)
# |> elem(0)

Day1.part1()
|> elem(1)
|> IO.inspect(label: "The answer to part 1 is")
