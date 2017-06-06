defmodule TodoList do

  def new, do: MultiMap.new

  def add_entry(todo_list, date, title) do
    MultiMap.add(todo_list, date, title)
  end

  def add_entry(todo_list, entry) do
    MultiMap.add(todo_list, entry.date, entry)
  end

  def entries(todo_list, date) do
    MultiMap.get(todo_list, date)
  end
end
