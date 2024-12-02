defmodule Solution do
  def part_1 do
    Enum.reduce(read_input(), 0, fn levels, acc ->
      if report_safe?(levels), do: acc + 1, else: acc
    end)
  end

  defp report_safe?([a, b | _rest] = levels) do
    comparator = get_comparator(a, b)
    report_safe?(levels, comparator)
  end

  defp report_safe?([a, b], comparator) do
    safe?(a, b, comparator)
  end

  defp report_safe?([a, b | rest], comparator) do
    if safe?(a, b, comparator) do
      report_safe?([b | rest], comparator)
    else
      false
    end
  end

  defp safe?(a, b, comparator) do
    comparator.(a, b) && abs(a - b) in 1..3
  end

  defp get_comparator(a, b) do
    cond do
      a > b ->
        &Kernel.>/2

      a < b ->
        &Kernel.</2

      true ->
        fn _a, _b -> false end
    end
  end

  def part_2 do
  end

  defp read_input(test? \\ false) do
    if test? do
      """
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
      """
    else
      File.read!("input.txt")
    end
    |> String.split("\n", trim: true)
    |> Enum.map(fn report ->
      report |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end
end

Solution.part_1() |> dbg

