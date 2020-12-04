defmodule Day4 do
  @required_fields ~w(byr iyr eyr hgt hcl ecl pid)a

  def input do
    # File.stream!("./test.txt")
    File.stream!("./day4.txt")
    |> Enum.reduce({[], []}, fn
      l, {current, acc} when l == "\n" ->
        {[], [Map.new(current) | acc]}

      l, {current, acc} ->
        line =
          String.split(l, [" ", "\n"], trim: true)
          |> Enum.map(fn l ->
            [key, value] = String.split(l, ":")
            {String.to_atom(key), value}
          end)

        {line ++ current, acc}
    end)
    # Since File.stream! does not return :eof or any other indication that the
    # file has ended the last set of data was stuck. I could have added a new
    # line to the input file to get around this issue without this function but
    # that seemed like cheating.
    |> (fn {last, acc} -> [Map.new(last) | acc] end).()
  end

  def count_valid_data1(data) do
    do_count_valid_data1(data, 0)
  end

  def do_count_valid_data1([], count), do: count

  def do_count_valid_data1([h | t], count) do
    valid? = Enum.all?(@required_fields, &Map.has_key?(h, &1))
    count = if valid?, do: count + 1, else: count

    do_count_valid_data1(t, count)
  end

  def part1 do
    input()
    |> count_valid_data1()
    |> IO.inspect()
  end
end

Day4.part1()
