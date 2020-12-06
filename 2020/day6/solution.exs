defmodule Day6 do
  def part1(input) do
    input
    |> get_count()
  end

  def part2 do
  end

  def input(test? \\ false) do
    path = if test?, do: "./test.txt", else: "./day6.txt"

    File.stream!(path)
  end

  def get_count(answers) do
    answers
    |> Enum.reduce({MapSet.new(), 0, 0}, fn
      "\n", {_seen, count, total} ->
        {MapSet.new(), 0, count + total}

      answers, {seen, count, total} ->
        {seen, count} =
          String.split(answers, "", trim: true)
          |> Enum.reduce({seen, count}, fn
            "\n", acc ->
              acc

            answer, {seen, count} ->
              count = if answer in seen, do: count, else: count + 1
              seen = MapSet.put(seen, answer)
              {seen, count}
          end)

        {seen, count, total}
    end)
    # Grab the last one since it doesn't have an extra new line
    |> (fn {_, count, total} -> count + total end).()
  end
end

Day6.input()
|> Day6.part1()
|> IO.inspect(label: "The answer to part 1 is")
