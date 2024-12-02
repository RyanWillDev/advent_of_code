defmodule Solution do
  def part_1 do
    answer =
      "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], []}, fn line, {a, b} ->
        [num_a, num_b] =
          line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

        {[num_a | a], [num_b | b]}
      end)
      |> then(fn {a, b} ->
        a = Enum.sort(a)
        b = Enum.sort(b)
        Enum.zip(a, b)
      end)
      |> Enum.reduce(0, fn {a, b}, acc ->
        abs(a - b) + acc
      end)

    IO.puts("Part 1: #{answer}")
  end

  def part_2 do
    {numbers, freqs} =
      "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], %{}}, fn line, {a, b} ->
        [num_a, num_b] =
          line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

        b = Map.update(b, num_b, 1, &(&1 + 1))

        {[num_a | a], b}
      end)

    answer =
      Enum.reduce(numbers, 0, fn n, acc ->
        n_freq = Map.get(freqs, n, 0)
        similarity_score = n * n_freq
        acc + similarity_score
      end)

    IO.puts("Part 2: #{answer}")
  end
end

Solution.part_1()
Solution.part_2()
