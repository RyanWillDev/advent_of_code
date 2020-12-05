defmodule Day5 do
  @column_space Enum.to_list(0..7)
  @row_space Enum.to_list(0..127)
  @possible_ids MapSet.new(0..1_023)

  def get_input(test?) do
    path = if test?, do: "./test.txt", else: "./day5.txt"

    File.read!(path)
    |> String.split("\n", trim: true)
  end

  def seat_id(row, column) do
    row * 8 + column
  end

  def column({rows, columns}) do
    column =
      Enum.reduce(columns, @column_space, &shrink_space(&1, &2, "R"))
      |> List.first()

    {rows, column}
  end

  def row({rows, columns}) do
    row =
      Enum.reduce(rows, @row_space, &shrink_space(&1, &2, "B"))
      |> List.first()

    {row, columns}
  end

  def shrink_space(bit, space, high) do
    splitter = if bit == high, do: -1, else: 1

    Enum.take(space, splitter * div(length(space), 2))
  end

  def shrink_space([x], _), do: x

  def split_bits(bits) do
    bits
    |> String.split("", trim: true)
    |> Enum.split(7)
  end

  def part1(test? \\ false) do
    get_input(test?)
    |> Enum.reduce(-1, fn pass, highest ->
      {row, column} =
        pass
        |> split_bits()
        |> row
        |> column()

      id = seat_id(row, column)
      if id > highest, do: id, else: highest
    end)
  end

  def part2(test? \\ false) do
    scanned_id_set =
      get_input(test?)
      |> Enum.map(fn pass ->
        {row, column} =
          pass
          |> split_bits()
          |> row
          |> column()

        seat_id(row, column)
      end)
      |> MapSet.new()

    missing_ids = MapSet.difference(@possible_ids, scanned_id_set)

    Enum.reduce(missing_ids, nil, fn curr_id, seat_id ->
      found? = (curr_id + 1) in scanned_id_set and (curr_id - 1) in scanned_id_set

      if found?, do: curr_id, else: seat_id
    end)
  end
end

Day5.part1()
|> IO.inspect(label: "The answer to part 1 is")

Day5.part2()
|> IO.inspect(label: "The answer to part 2 is")
