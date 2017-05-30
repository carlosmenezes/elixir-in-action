defmodule Recursion do

  def list_len([]), do: 0

  def list_len([_ | t]), do: list_len(t) + 1

  def range(from, to) when from > to, do: []

  def range(from, to), do: [from | range(from + 1, to)]

  def positive([]), do: []

  def positive([h | t]) when h < 0, do: positive(t)

  def positive([h | t]), do: [h | positive(t)]
end

IO.puts("====== Recursion tests ======")

IO.puts("List length: ")
list = [1, 2, 3]
IO.puts("Expected length: 3")
IO.puts("Result: #{Recursion.list_len(list)}")

IO.puts("List from range: 1 to 10")
IO.inspect(Recursion.range(1, 10), label: "Result")

int_list = [12, -2, 34, -4, -9, 14, -5, 8]
IO.inspect(int_list, label: "Filter positive numbers")
IO.inspect(Recursion.positive(int_list), label: "Result")
