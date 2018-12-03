defmodule AOC do
  def read_input(path) do
    Path.join([System.cwd(), path, "input.txt"])
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
