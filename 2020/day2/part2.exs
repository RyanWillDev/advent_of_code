parse_line = fn l ->
  l
  |> String.split(" ", trim: true)
  |> (fn [policy, letter, pass] ->
        [pos1, pos2] =
          policy
          |> String.split("-")
          |> Enum.map(&String.to_integer/1)

        [letter, _] = String.split(letter, ":")

        %{pos1: pos1 - 1, pos2: pos2 - 1, letter: letter, pass: pass}
      end).()
end

File.read!("./day2.txt")
|> String.split("\n", trim: true)
|> Enum.reduce(0, fn l, acc ->
  %{pos1: pos1, pos2: pos2, letter: letter, pass: pass} = parse_line.(l)

  pos1 = String.at(pass, pos1)
  pos2 = String.at(pass, pos2)

  if (pos1 == letter && pos2 != letter) ||
       (pos1 != letter && pos2 == letter) do
    acc + 1
  else
    acc
  end
end)
|> IO.inspect(label: "Number of valid passwords")
