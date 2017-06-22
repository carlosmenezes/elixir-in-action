defmodule KeyValueStore do
  use GenServer

  def init(_), do: {:ok, %{}}

  def handle_cast({:put, key, value}, state), do: {:noreply, Map.put(state, key, value)}

  def handle_call({:get, key}, _, state), do: {:reply, Map.get(state, key), state}

  def start, do: GenServer.start(KeyValueStore, nil)

  def put(pid, key, value), do: GenServer.cast(pid, {:put, key, value})

  def get(pid, key), do: GenServer.call(pid, {:get, key})

end
