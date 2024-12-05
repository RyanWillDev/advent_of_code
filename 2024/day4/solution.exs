defmodule Solution do
  def part_1 do
    coords = build_coordinates(read_input())
    last = coords |> Enum.max() |> elem(0)
    match_fns = [&vertical_match_count/3, &horizontal_match_count/3, &diagonal_match_count/3]
    ctx = %{count: 0, match_fns: match_fns, key_letter: "X", string: "XMAS"}

    check_grid(coords, {0, 0}, last, ctx)
  end

  def part_2 do
    coords = build_coordinates(read_input(true))
    last = coords |> Enum.max() |> elem(0)

    match_fns = [&x_match_count/3]
    ctx = %{count: 0, match_fns: match_fns, key_letter: "M", string: "MAS"}

    check_grid(coords, {0, 0}, last, ctx)
  end

  defp check_grid(_coords, {current_r, _c}, {max_r, _max_c}, %{count: count})
       when current_r > max_r do
    count
  end

  defp check_grid(coords, {r, c} = location, {_max_r, max_c} = last, ctx) do
    %{count: count, match_fns: match_fns, key_letter: key, string: string} = ctx
    letter = Map.get(coords, location, "")

    count =
      if letter == key do
        Enum.reduce(match_fns, count, fn
          match_fn, count ->
            match_fn.(coords, location, string) + count
        end)
      else
        count
      end

    location = if c == max_c, do: {r + 1, 0}, else: {r, c + 1}

    check_grid(coords, location, last, %{ctx | count: count})
  end

  defp vertical_match_count(coords, {c, r}, string) do
    coords
    |> get_letters(num_moves(string), {&Kernel.+(&1, c), fn _ -> r end})
    |> Enum.count(&check_match(&1, string))
  end

  defp horizontal_match_count(coords, {c, r}, string) do
    coords
    |> get_letters(num_moves(string), {fn _ -> c end, &Kernel.+(&1, r)})
    |> Enum.count(&check_match(&1, string))
  end

  defp diagonal_match_count(coords, {c, r}, string) do
    right_slant =
      coords
      |> get_letters(num_moves(string), {&Kernel.+(&1, c), &Kernel.+(&1, r)})
      |> Enum.count(&check_match(&1, string))

    left_slant =
      coords
      |> get_letters(num_moves(string), {&Kernel.+(&1 * -1, c), &Kernel.+(&1, r)})
      |> Enum.count(&check_match(&1, string))

    left_slant + right_slant
  end

  defp x_match_count(coords, {c, r}, string) do
    right_slant =
      coords
      |> get_letters(num_moves(string), {&Kernel.+(&1, c), &Kernel.+(&1, r)})
      |> Enum.count(&check_match(&1, string))

    left_slant =
      coords
      |> get_letters(num_moves(string), {&Kernel.+(&1, c + 2), &Kernel.+(&1 * -1, r)})
      |> dbg
      |> Enum.count(&check_match(&1, string))

    if left_slant + right_slant == 2, do: 1, else: 0
  end

  defp get_letters(coords, num_moves, {move_c, move_r}) do
    {before_leters, after_letters} =
      Enum.reduce(0..num_moves, {[], []}, fn n, {before_letters, after_letters} ->
        before_coords = {move_c.(n * -1), move_r.(n * -1)}
        after_coords = {move_c.(n), move_r.(n)}

        before_letter = Map.get(coords, before_coords, "")
        after_letter = Map.get(coords, after_coords, "")

        {[before_letter | before_letters], [after_letter | after_letters]}
      end)

    Enum.map([before_leters, after_letters], fn ls ->
      ls |> Enum.reverse() |> Enum.join("")
    end)
  end

  defp check_match(string, string), do: true
  defp check_match(_, _), do: false

  defp num_moves(string), do: String.length(string) - 1

  defp build_coordinates(rows) do
    rows
    |> Enum.reduce({0, %{}}, fn row, {row_index, coords} ->
      coords =
        row
        |> String.split("", trim: true)
        |> Enum.with_index(&{{row_index, &2}, &1})
        |> Map.new()
        |> Map.merge(coords)

      {row_index + 1, coords}
    end)
    |> elem(1)
  end

  defp read_input(test? \\ false) do
    if test? do
      """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """

      """
      MBS
      BAB
      MBS
      """
    else
      File.read!("input.txt")
    end
    |> String.trim()
    |> String.split("\n", trim: true)
  end
end

Solution.part_1() |> dbg
# Solution.part_2() |> dbg
