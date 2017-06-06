defmodule MultiMap do

  def new, do: %{}

  def add(map, key, value) do
    Map.update(map, key, [value], &[value | &1])
  end

  def get(map, key) do
    Map.get(map, key, [])
  end
end
