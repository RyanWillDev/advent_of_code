defmodule Day7 do
  def part1(rules) do
    rules
    |> Enum.map(&parse_rule/1)
  end

  def parse_rule(rule) do
    String.split(rule, [" contain ", ",", ", ", "."], trim: true)
    |> Enum.map(fn part ->
      s = [h | t] = String.split(part, " ", trim: true)
      IO.inspect(h, label: "what is head")

      if String.to_integer(h) in 0..9 do
        IO.inspect(part)
      else
        IO.inspect(part)
      end
    end)
  end

  def input(test? \\ false) do
    path = if test?, do: "./test.txt", else: "./day7.txt"

    File.read!(path)
    |> String.split("\n")
  end
end

Day7.input(true)
|> Day7.part1()
|> IO.inspect()
