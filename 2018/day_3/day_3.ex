defmodule AOC.TwentyEighteen.Day3 do
  def part_one() do
  end

  def read_and_parse_input() do
    AOC.read_input("2018/day_3")
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn claim, {seen, duplicated_claims} ->
      current_claim_area = parse_claim_parts(claim) |> get_claimed_area()

      cond do
        MapSet.size(seen) == 0 ->
          {current_claim_area, duplicated_claims}

        true ->
          overlap = MapSet.intersection(current_claim_area, seen)

          {MapSet.union(current_claim_area, seen), MapSet.union(duplicated_claims, overlap)}
      end
    end)
    |> elem(1)
    |> MapSet.size()
  end

  def parse_claim_parts(claim) do
    ["#" <> id, _, offsets, dimensions] = String.split(claim, " ", trim: true)
    [left_offset, top_offset] = String.split(offsets, [",", ":"], trim: true)
    [width, height] = String.split(dimensions, "x", trim: true)

    [id, left_offset, top_offset, width, height] |> Enum.map(&String.to_integer/1)
  end

  def get_claimed_area([_id, left_offset, top_offset, width, height]) do
    for x <- (top_offset + 1)..(top_offset + height) do
      for y <- (left_offset + 1)..(left_offset + width) do
        {x, y}
      end
    end
    |> List.flatten()
    |> MapSet.new()
  end

  def test_input() do
    [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]
  end
end
