defmodule AOC.TwentyEighteen.Day1 do
  @moduledoc """
  https://adventofcode.com/2018/day/1
  """
  def part_1 do
    input() |> parse() |> Enum.sum()
  end

  def part_2 do
    input() |> parse() |> part_2(0, %{})
  end

  def part_2([current | rest] = _frequencies, total, record) do
    total = current + total
    record = Map.update(record, total, 1, &(&1 + 1))

    case record[total] do
      n when n > 1 ->
        total

      _ ->
        part_2(rest, total, record)
    end
  end

  def part_2([], total, record) do
    input()
    |> parse()
    |> part_2(total, record)
  end

  def parse(input) do
    input
    |> Enum.map(fn s ->
      String.trim(s)
      |> String.to_integer()
    end)
  end

  def input do
    AOC.read_input("2018/day_1")
  end
end
