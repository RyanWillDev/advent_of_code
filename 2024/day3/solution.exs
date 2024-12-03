defmodule Parser do
  defstruct cursor: nil, input: [], operations: [], conditionals?: false, disabled?: false

  def parse([h | rest], conditionals? \\ false) do
    read_char(%__MODULE__{cursor: h, input: rest, conditionals?: conditionals?})
  end

  def eval(%__MODULE__{operations: ops}) do
    Enum.reduce(ops, 0, &(&1.() + &2))
  end

  defp read_char(%{input: []} = parser), do: parser

  defp read_char(%{cursor: ?m} = parser), do: read_keyword(parser, [])

  defp read_char(%{cursor: ?d, conditionals?: true} = parser), do: read_conditional(parser, [])

  defp read_char(parser) do
    parser
    |> advance_cursor()
    |> read_char()
  end

  defp read_keyword(%{disabled?: true} = parser, _buffer) do
    parser
    |> advance_cursor()
    |> read_char()
  end

  @keyword ~c"mul"
  defp read_keyword(%{cursor: c} = parser, buffer) when c in @keyword do
    parser
    |> advance_cursor()
    |> read_keyword(buffer ++ [c])
  end

  defp read_keyword(%{cursor: ?(} = parser, @keyword) do
    parser
    |> advance_cursor()
    |> read_integer([], [])
  end

  defp read_keyword(parser, _buffer), do: read_char(parser)

  @int ?0..?9
  defp read_integer(%{cursor: c, input: [?, | _t]} = parser, buffer, integers)
       when c in @int do
    buffer = buffer ++ [c]
    integer = buffer |> to_string() |> String.to_integer()

    parser
    |> advance_cursor(2)
    |> read_integer([], [integer | integers])
  end

  defp read_integer(%{cursor: c, input: [?) | _t], operations: ops} = parser, buffer, integers)
       when c in @int do
    buffer = buffer ++ [c]

    integers =
      buffer |> to_string() |> String.to_integer() |> List.wrap() |> Enum.concat(integers)

    %{parser | operations: [fn -> apply(Kernel, :*, integers) end | ops]}
    |> advance_cursor(2)
    |> read_char()
  end

  defp read_integer(%{cursor: c} = parser, buffer, integers) when c in @int do
    parser
    |> advance_cursor()
    |> read_integer(buffer ++ [c], integers)
  end

  defp read_integer(parser, _buffer, _ints), do: read_char(parser)

  @conditional_chars ~c"do'nt"
  defp read_conditional(%{cursor: c} = parser, buffer) when c in @conditional_chars do
    parser
    |> advance_cursor()
    |> read_conditional(buffer ++ [c])
  end

  defp read_conditional(%{cursor: ?(, input: [h | t]} = parser, buffer) do
    diabled? =
      case buffer do
        ~c"do" -> false
        ~c"don't" -> true
      end

    %{parser | cursor: h, input: t, disabled?: diabled?}
    |> advance_cursor()
    |> read_char()
  end

  defp read_conditional(parser, _buffer), do: read_char(parser)

  defp advance_cursor(parser, steps \\ 1)
  defp advance_cursor(%{input: [h | t]} = parser, 1), do: %{parser | cursor: h, input: t}

  defp advance_cursor(%{input: [h | t]} = parser, steps) do
    advance_cursor(%{parser | cursor: h, input: t}, steps - 1)
  end
end

defmodule Solution do
  def part_1 do
    read_input()
    |> Parser.parse()
    |> Parser.eval()
  end

  def part_2 do
    read_input()
    |> Parser.parse(true)
    |> Parser.eval()
  end

  defp read_input(test? \\ false) do
    if test? do
      # Part 1 test
      # xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))

      # Part 2 test
      """
      xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
      """
    else
      File.read!("input.txt")
    end
    |> String.trim()
    |> String.to_charlist()
  end
end

Solution.part_1() |> dbg
Solution.part_2() |> dbg
