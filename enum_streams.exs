defmodule EnumStreams do

  def lines_lengths!(file) do
    File.stream!(file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.with_index
    |> Enum.each(fn({line, index}) ->
      IO.puts("Line ##{index + 1} length: #{String.length(line)}")
    end)
  end

  def longest_line_length!(file) do
    File.stream!(file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.length(&1))
    |> Stream.with_index
    |> Enum.max_by(&(elem(&1, 0)))
  end

  def longest_line!(file) do
    File.stream!(file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.with_index
    |> Enum.max_by(&(String.length(elem(&1, 0))))
  end

  # words_per_line!/1 that returns a list of numbers, with each number represent-
  # ing the word count in a file. Hint: to get the word count of a line, use length(String.split(line)).

  def words_per_line!(file) do
    File.stream!(file)
    |> Stream.map(fn(line) ->
      line
      |> String.replace("\n", "")
      |> String.split(~r{\s}, trim: true)
      |> length
    end)
    |> Stream.with_index
    |> Enum.to_list
  end
end

IO.puts("====== Enums and Streams tests ======\n")
IO.puts("Line lengths:")
EnumStreams.lines_lengths!("/Users/carlos/Projetos/elixir/elixir-in-action/enum_streams.exs")

IO.puts("\nLongest line length:")
longest_line = EnumStreams.longest_line_length!("/Users/carlos/Projetos/elixir/elixir-in-action/enum_streams.exs")
IO.puts("Result: Line ##{elem(longest_line, 1) + 1}, #{elem(longest_line, 0)} characters")

IO.puts("\nLongest line contents:")
longest_line = EnumStreams.longest_line!("/Users/carlos/Projetos/elixir/elixir-in-action/enum_streams.exs")
IO.puts("Result: Line ##{elem(longest_line, 1) + 1}, contents => #{elem(longest_line, 0)}")

IO.puts("\nWord count per line:")
EnumStreams.words_per_line!("/Users/carlos/Projetos/elixir/elixir-in-action/enum_streams.exs")
|> Enum.each(fn({count, line_number}) ->
  IO.puts("Line ##{line_number}: #{count} word(s).")
end)
