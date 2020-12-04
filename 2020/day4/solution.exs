defmodule Day4 do
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

  def field_valid?(_, nil), do: false

  def field_valid?(:byr, v) do
    y = String.to_integer(v)
    y >= 1920 && y <= 2002
  end

  def field_valid?(:iyr, v) do
    y = String.to_integer(v)
    y >= 2010 && y <= 2020
  end

  def field_valid?(:eyr, v) do
    y = String.to_integer(v)
    y >= 2020 && y <= 2030
  end

  def field_valid?(:hgt, v) do
    r = ~r/(?<num>\d+)(?<type>(cm|in))/

    case Regex.named_captures(r, v) do
      %{"type" => "cm", "num" => n} ->
        n = String.to_integer(n)
        n >= 150 && n <= 193

      %{"type" => "in", "num" => n} ->
        n = String.to_integer(n)
        n >= 59 && n <= 76

      _ ->
        false
    end
  end

  def field_valid?(:hcl, "#" <> v) do
    valid_chars? =
      String.split(v, "", trim: true)
      |> Enum.all?(fn c ->
        ascii = :binary.first(c)

        # Need to git gud at Regex
        ascii in (Enum.to_list(92..102) ++ Enum.to_list(48..57))
      end)

    String.length(v) == 6 && valid_chars?
  end

  def field_valid?(:ecl, v) when v in ~w(amb blu brn gry grn hzl oth), do: true

  def field_valid?(:pid, v) do
    # Will raise if given something that can't be converted to a number
    _ = String.to_integer(v)
    String.length(v) == 9
  rescue
    ArgumentError ->
      false
  end

  def field_valid?(_, _), do: false

  def count_valid_data1(data) do
    do_count_valid_data1(data, 0)
  end

  def do_count_valid_data1([], count), do: count

  def do_count_valid_data1([h | t], count) do
    valid? = Enum.all?(~w(byr iyr eyr hgt hcl ecl pid)a, &Map.has_key?(h, &1))
    count = if valid?, do: count + 1, else: count

    do_count_valid_data1(t, count)
  end

  def count_valid_data2(data) do
    do_count_valid_data2(data, 0)
  end

  def do_count_valid_data2([], count), do: count

  def do_count_valid_data2([h | t], count) do
    valid? =
      Enum.all?(~w(byr iyr eyr hgt hcl ecl pid)a, fn key ->
        field_valid?(key, Map.get(h, key))
      end)

    count = if valid?, do: count + 1, else: count

    do_count_valid_data2(t, count)
  end

  def part1 do
    input()
    |> count_valid_data1()
    |> IO.inspect(label: "Part 1 answer")
  end

  def part2 do
    input()
    |> count_valid_data2()
    |> IO.inspect(label: "Part 2 answer")
  end
end

Day4.part1()
Day4.part2()
