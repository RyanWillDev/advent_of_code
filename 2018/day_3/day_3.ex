defmodule AOC.TwentyEighteen.Day3 do
  def part_one() do
  end

  def read_and_parse_input() do
    test_input()

    AOC.read_input("2018/day_3")
    # |> Enum.take(2)
    |> Enum.reduce({0, MapSet.new(), MapSet.new()}, fn claim, {overlap, seen, claimed} ->
      [left_offset, top_offset, width, height] = parse_claim_parts(claim)

      with current_claimed_area <- get_claimed_area(left_offset, top_offset, width, height),
           #  |> IO.inspect(label: "intersection")
           overlapping <-
             MapSet.intersection(current_claimed_area, seen)
             |> (fn i ->
                   if MapSet.size(claimed) > 0, do: MapSet.intersection(i, claimed), else: i
                 end).() do
        claimed = MapSet.union(claimed, overlapping)
        seen = MapSet.union(current_claimed_area, seen)
        {overlap + MapSet.size(overlapping), seen, claimed}
      end
    end)
    |> elem(0)
  end

  def parse_claim_parts(claim) do
    [_, _, offsets, dimensions] = String.split(claim, " ", trim: true)
    [left_offset, top_offset] = String.split(offsets, [",", ":"], trim: true)
    [width, height] = String.split(dimensions, "x", trim: true)

    [left_offset, top_offset, width, height] |> Enum.map(&String.to_integer/1)
  end

  def get_claimed_area(top_offset, left_offset, width, height) do
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
