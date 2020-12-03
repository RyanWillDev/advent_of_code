parse_line = fn l ->
  l
  |> String.split(" ", trim: true)
  |> (fn [policy, letter, pass] ->
        [min, max] =
          policy
          |> String.split("-")
          |> Enum.map(&String.to_integer/1)

        [letter, _] = String.split(letter, ":")

        %{min: min, max: max, letter: letter, pass: pass}
      end).()
end

File.read!("./day2.txt")
|> String.split("\n", trim: true)
|> Enum.reduce(0, fn l, acc ->
  %{min: min, max: max, letter: letter, pass: pass} = parse_line.(l)

  frequency =
    String.split(pass, "", trim: true)
    |> Enum.frequencies_by(&Function.identity/1)
    |> Map.get(letter, 0)

  if frequency >= min && frequency <= max do
    acc + 1
  else
    acc
  end
end)
|> IO.inspect(label: "Number of valid passwords")
