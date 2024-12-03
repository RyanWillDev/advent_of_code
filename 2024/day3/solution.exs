defmodule Parser do
  defstruct cursor: nil, input: [], operations: []

  def parse([h | rest]), do: read_char(%__MODULE__{cursor: h, input: rest})

  def eval(%__MODULE__{operations: ops}) do
    Enum.reduce(ops, 0, &(&1.() + &2))
  end

  defp read_char(%{input: []} = parser), do: parser

  defp read_char(%{cursor: ?m} = parser), do: read_keyword(parser, [])

  defp read_char(%{input: [h | t]} = parser), do: read_char(%{parser | cursor: h, input: t})

  @keyword ~c"mul"
  defp read_keyword(%{cursor: c, input: [h | t]} = parser, buffer) when c in @keyword do
    parser = %{parser | cursor: h, input: t}
    read_keyword(parser, buffer ++ [c])
  end

  defp read_keyword(%{cursor: ?(, input: [h | t]} = parser, @keyword) do
    parser = %{parser | cursor: h, input: t}
    read_integer(parser, [], [])
  end

  defp read_keyword(parser, _buffer), do: read_char(parser)

  @int ?0..?9
  defp read_integer(%{cursor: c, input: [?, | t]} = parser, buffer, integers)
       when c in @int do
    buffer = buffer ++ [c]
    integer = buffer |> to_string() |> String.to_integer()

    [h | t] = t
    parser = %{parser | cursor: h, input: t}

    read_integer(parser, [], [integer | integers])
  end

  @int ?0..?9
  defp read_integer(%{cursor: c, input: [?) | t], operations: ops} = parser, buffer, integers)
       when c in @int do
    buffer = buffer ++ [c]

    integers =
      buffer |> to_string() |> String.to_integer() |> List.wrap() |> Enum.concat(integers)

    [h | t] = t

    parser = %{
      parser
      | cursor: h,
        input: t,
        operations: [fn -> apply(Kernel, :*, integers) end | ops]
    }

    read_char(parser)
  end

  defp read_integer(%{cursor: c, input: [h | t]} = parser, buffer, integers) when c in @int do
    parser = %{parser | cursor: h, input: t}
    read_integer(parser, buffer ++ [c], integers)
  end

  defp read_integer(parser, _buffer, _ints), do: read_char(parser)
end

defmodule Solution do
  def part_1 do
    read_input()
    |> Parser.parse()
    |> Parser.eval()
  end

  defp read_input(test? \\ false) do
    if test? do
      """
      xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
      """
    else
      File.read!("input.txt")
    end
    |> String.trim()
    |> String.to_charlist()
  end
end

Solution.part_1() |> dbg
