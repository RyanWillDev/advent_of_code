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

  @doc """
  Uses a binary search to shrink the possible seat space until we find a single value.

  If the given "bit" is the high bit, meaning the one representing the upper half of the space then
  split the list in half taking the higher space using a negative number.
  Otherwise, we keep the lower space by keeping the bottom half of the list.

  Possible improvement:
  We check the length of the list each time this function is called.
  That means we have to walk the list each time.
  The calling function could provide the length and checking once and then just half it each iteration.
  """
  def shrink_space(bit, space, high) do
    splitter = if bit == high, do: -1, else: 1

    Enum.take(space, splitter * div(length(space), 2))
  end

  @doc """
  The list of characters are in the shape of `FBFBBFFRLR`.

  The first 7 characters, or bits, indicate which of the 128 rows this ticket represents,
  while the last 3 indicate which of the 8 seats the ticket represents.

  We will split on the 7th character to separate the ones representing the row and seat.
  """
  def split_bits(bits) do
    bits
    |> String.split("", trim: true)
    |> Enum.split(7)
  end

  @doc """
  Calculates the seat id of every ticket returning the highest.
  """
  def part1(test? \\ false) do
    get_input(test?)
    |> Enum.reduce(-1, fn pass, highest ->
      {row, column} =
        pass
        |> split_bits()
        |> row()
        |> column()

      id = seat_id(row, column)
      if id > highest, do: id, else: highest
    end)
  end

  @doc """
  Calculates the seat id on our missing ticket.

  Since we know that the seat id is represented by 10 characters, or bits, we know there are 1024 possible seat ids.
  We have list of all the other passenger's seat identifiers.
  We can generate the id for each of those and see which one is missing from the list of possible ids.

  Unfortunately, there are more than just our seat id missing.
  We are told that our seat id will be a seat that has the a seat on either side.
  """
  def part2(test? \\ false) do
    scanned_id_set =
      get_input(test?)
      |> Enum.map(fn pass ->
        {row, column} =
          pass
          |> split_bits()
          |> row()
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
