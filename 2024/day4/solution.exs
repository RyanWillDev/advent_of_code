defmodule Solution do
  def part_1 do
    coords = build_coordinates(read_input())
    last = coords |> Enum.max() |> elem(0)
    match_fns = [&vertical_match_count/3, &horizontal_match_count/3, &diagonal_match_count/3]
    ctx = %{count: 0, match_fns: match_fns, key_letter: "X", string: "XMAS"}

    check_grid(coords, {0, 0}, last, ctx)
  end

  def part_2 do
    coords = build_coordinates(read_input())
    last = coords |> Enum.max() |> elem(0)

    match_fns = [&x_match_count/3]
    ctx = %{count: 0, match_fns: match_fns, key_letter: "A", string: "MAS"}

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

  defp vertical_match_count(coords, {r, c}, string) do
    above = {&Kernel.-(r, &1), stationary(c)}
    below = {&Kernel.+(&1, r), stationary(c)}

    [above, below]
    |> Enum.map(&get_letters(coords, num_moves(string), &1))
    |> Enum.count(&check_match(&1, string))
  end

  defp horizontal_match_count(coords, {r, c}, string) do
    left = {stationary(r), &Kernel.-(c, &1)}
    right = {stationary(r), &Kernel.+(&1, c)}

    [left, right]
    |> Enum.map(&get_letters(coords, num_moves(string), &1))
    |> Enum.count(&check_match(&1, string))
  end

  defp diagonal_match_count(coords, {r, c}, string) do
    negative_slope_above = {&Kernel.-(r, &1), &Kernel.-(c, &1)}
    negative_slope_below = {&Kernel.+(r, &1), &Kernel.+(c, &1)}

    postive_slope_above = {&Kernel.-(r, &1), &Kernel.+(c, &1)}
    postive_slope_below = {&Kernel.+(r, &1), &Kernel.-(c, &1)}

    [negative_slope_above, negative_slope_below, postive_slope_above, postive_slope_below]
    |> Enum.map(&get_letters(coords, num_moves(string), &1))
    |> Enum.count(&check_match(&1, string))
  end

  defp x_match_count(coords, {r, c}, string) do
    # In order to use the same matching logic we move the locations of the diagonals
    # to the top and bottom left corners by incrementing and/or decrementing the row and column position
    top_left_corner_negative_slope = {&Kernel.+(r - 1, &1), &Kernel.+(c - 1, &1)}
    bottom_left_corner_positive_slope = {&Kernel.+(r - 1, &1), &Kernel.-(c + 1, &1)}

    count =
      [top_left_corner_negative_slope, bottom_left_corner_positive_slope]
      |> Enum.map(&get_letters(coords, num_moves(string), &1))
      |> Enum.count(&(check_match(&1, string) or check_match(&1, String.reverse(string))))

    # Both slopes must match
    if count == 2, do: 1, else: 0
  end

  defp get_letters(coords, num_moves, {move_r, move_c}) do
    0..num_moves
    |> Enum.reduce([], fn n, letters ->
      letter_coords = {move_r.(n), move_c.(n)}

      letter = Map.get(coords, letter_coords, "")
      [letter | letters]
    end)
    |> Enum.reverse()
    |> Enum.join("")
  end

  defp check_match(string, string), do: true
  defp check_match(_, _), do: false

  defp num_moves(string), do: String.length(string) - 1

  defp stationary(n), do: fn _ -> n end

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

      # Vertical Case: 2
      # """
      # XSAS
      # MAMX
      # AMSB
      # SXBB
      # """

      # Horizontal Case: 2
      # """
      # XMAS
      # SAMX
      # BBSB
      # BBBB
      # """

      # Diagonal Case: 4
      # """
      # XBBX
      # SMMX
      # BAAB
      # SBBS
      # BAAB
      # BMMB
      # XBBX
      # """

      # X-MAS Case: 1
      # """
      # MXS
      # XAX
      # MXS
      # """
    else
      File.read!("input.txt")
    end
    |> String.trim()
    |> String.split("\n", trim: true)
  end
end

Solution.part_1() |> dbg
Solution.part_2() |> dbg
