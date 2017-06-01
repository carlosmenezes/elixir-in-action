defmodule TailRecursion do

  def list_len(list) do
    compute_length(0, list)
  end

  defp compute_length(accumulator, []), do: accumulator

  defp compute_length(accumulator, [_ | t]) do
    compute_length(accumulator + 1, t)
  end

  def range(from, to) do
    compute_range(from, to, [])
  end

  defp compute_range(from, to, list) when from > to do
    list
  end

  defp compute_range(from, to, list) do
    compute_range(from, to - 1, [to | list])
  end

  def positive([h | t]) do
    filter_positives(h, t)
  end

  defp filter_positives(_, []), do: []

  defp filter_positives(number, [h | t]) when number < 0 do
    filter_positives(h, t)
  end

  defp filter_positives(number, [h | t]), do: [number | filter_positives(h, t)]
end

IO.puts("====== Tail recursion tests ======")

IO.puts("List length: ")
list = [1, 2, 3]
IO.puts("Expected length: 3")
IO.puts("Result: #{TailRecursion.list_len(list)}")


IO.puts("List from range: 1 to 10")
IO.inspect(TailRecursion.range(1, 10), label: "Result")

int_list = [12, -2, 34, -4, -9, 14, -5]
IO.inspect(int_list, label: "Filter positive numbers")
IO.inspect(TailRecursion.positive(int_list), label: "Result")
