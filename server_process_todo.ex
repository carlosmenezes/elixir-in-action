defmodule ServerProcess do

  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init
      loop(callback_module, initial_state)
    end)
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} -> response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(request, current_state)
        send(caller, {:response, response})
        loop(callback_module, new_state)
      {:cast, request} ->
        new_state = callback_module.handle_cast(request, current_state)
        IO.inspect new_state, label: "State"
        loop(callback_module, new_state)
    end
  end
end

defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def init, do: %TodoList{}

  def handle_cast({:add_entry, entry}, %TodoList{entries: entries, auto_id: auto_id} = state) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)

    %TodoList{state | entries: new_entries, auto_id: auto_id + 1}
  end

  def handle_cast({:update_entry, entry_id, updater_fun}, %TodoList{entries: entries} = state) do
    case entries[entry_id] do
      nil -> state

      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %TodoList{state | entries: new_entries}
    end
  end

  def handle_call({:entries, date}, %TodoList{entries: entries} = state) do
    result = entries
    |> Stream.filter(fn({_, entry}) -> entry.date == date end)
    |> Enum.map(fn({_, entry}) -> entry end)

    {result, state}
  end

  def handle_call({:delete_entry, entry_id}, %TodoList{entries: entries} = state) do
    new_state = %TodoList{state | entries: Map.delete(entries, entry_id)}
    {new_state, new_state}
  end

  def start do
    ServerProcess.start(TodoList)
  end

  def add_entry(server_pid, entry) do
    ServerProcess.cast(server_pid, {:add_entry, entry})
  end

  def entries(server_pid, date) do
    ServerProcess.call(server_pid, {:entries, date})
  end

  def update_entry(server_pid, entry_id, updater_fun) do
    ServerProcess.cast(server_pid, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(server_pid, entry_id) do
    ServerProcess.call(server_pid, {:delete_entry, entry_id})
  end
end
