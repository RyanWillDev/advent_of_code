defmodule Solution do
  def part_1 do
    Enum.reduce(read_input(), 0, fn report, acc ->
      if report_safe?(report), do: acc + 1, else: acc
    end)
  end

  def part_2 do
    Enum.reduce(read_input(), 0, fn report, acc ->
      if report_safe?(report, true), do: acc + 1, else: acc
    end)
  end

  defp report_safe?([a, b | _rest] = levels, dampen? \\ false) do
    compare_fn = get_comparator(a, b)
    levels_safe?(levels, %{compare_fn: compare_fn, prev: [], dampen?: dampen?})
  end

  defp levels_safe?([_level], _ctx), do: true

  defp levels_safe?(
         [a, b | rest] = levels,
         %{compare_fn: compare, dampen?: dampen?, prev: prev} = ctx
       ) do
    cond do
      safe?(a, b, compare) ->
        levels_safe?([b | rest], %{ctx | prev: prev ++ [a]})

      dampen? ->
        without_a = prev ++ [b] ++ rest
        without_b = prev ++ [a] ++ rest

        # If prev only contains the first element we can attempt a report without it
        report_safe?(without_a, false) or
          report_safe?(without_b, false) or
          (length(prev) == 1 && report_safe?(levels, false))

      true ->
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

  defp read_input(test? \\ false) do
    if test? do
      # Edge cases
      """
      2 6 9 10 11 12
      1 2 3 4 5 4
      1 1 2 3 4 5
      """

      # """
      # 7 6 4 2 1
      # 1 2 7 8 9
      # 9 7 6 2 1
      # 1 3 2 4 5
      # 8 6 4 4 1
      # 1 3 6 7 9
      # """
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
Solution.part_2() |> dbg
