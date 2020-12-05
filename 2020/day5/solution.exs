defmodule Day5 do
  @column_space Enum.to_list(0..7)
  @row_space Enum.to_list(0..127)

  # For example, consider just the first seven characters of FBFBBFFRLR:
  #
  #    Start by considering the whole range, rows 0 through 127.
  #    F means to take the lower half, keeping rows 0 through 63.
  #    B means to take the upper half, keeping rows 32 through 63.
  #    F means to take the lower half, keeping rows 32 through 47.
  #    B means to take the upper half, keeping rows 40 through 47.
  #    B keeps rows 44 through 47.
  #    F keeps rows 44 through 45.
  #    The final F keeps the lower of the two, row 44.
  #
  # For example, consider just the last 3 characters of FBFBBFFRLR:
  #
  #    Start by considering the whole range, columns 0 through 7.
  #    R means to take the upper half, keeping columns 4 through 7.
  #    L means to take the lower half, keeping columns 4 through 5.
  #    The final R keeps the upper of the two, column 5.
  #
  # Every seat also has a unique seat ID: multiply the row by 8, then add the column.
  #
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

  def part2 do
  end
end

Day5.part1()
|> IO.inspect(label: "The answer to part 1 is")
