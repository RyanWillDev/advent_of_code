defmodule Day3 do
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

  defp continue_slope({x, y}, {xslope, yslope}), do: {x + xslope, y + yslope}

  defp traverse_map(map, slope) do
    Enum.reduce(map, {0, {0, 0}, 0}, fn l, {i, {x, y} = point, trees} ->
      # If we are past {0, 0} (point) and the slope has moved our next point
      # past the current line (l), we need to skip this line.
      if y == i && y >= 0 do
        line = String.split(l, "", trim: true)

        if check_tree(line, x) do
          {i + 1, continue_slope(point, slope), trees + 1}
        else
          {i + 1, continue_slope(point, slope), trees}
        end
      else
        {i + 1, point, trees}
      end
    end)
  end

  def part1 do
    File.read!("./day3.txt")
    |> String.split("\n", trim: true)
    |> traverse_map({3, 1})
    |> elem(2)
  end

  def part2 do
    slopes = [{1, 1}, {5, 1}, {7, 1}, {1, 2}]

    map =
      File.read!("./day3.txt")
      |> String.split("\n", trim: true)

    Enum.map(slopes, fn slope -> Task.async(fn -> traverse_map(map, slope) end) end)
    |> Task.yield_many()
    |> Enum.map(fn {_, {:ok, {_, _, trees}}} -> trees end)
    |> Enum.reduce(1, &(&1 * &2))
  end
end



a =
  Day3.part1()
  |> IO.inspect(label: "The answer to part 1 is")

Day3.part2()
|> (fn b -> a * b end).()
|> IO.inspect(label: "The answer to part 2 is")
