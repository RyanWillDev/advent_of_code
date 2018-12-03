alias AOC.TwentyEighteen.Day1
IO.puts("The answer to Part 1: #{Day1.part_1()} \n")
{time, value} = :timer.tc(&Day1.part_2/0)
time = time / 1000
IO.puts("The answer to Part 2: #{value}")
IO.puts("Time to solve Part 2: #{time}ms")
