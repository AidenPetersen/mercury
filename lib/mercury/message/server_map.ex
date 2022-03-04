defmodule Mercury.Message.ServerMap do
  use GenServer
  alias Mercury.Message

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(_) do
    {:ok, %{}}
  end


  @impl true
  def handle_cast({:leave, name, user}, state) do
    server = state[name]

    _ = GenServer.cast(server, {:leave, user})
    users = GenServer.call(server, :users)
    num_users = length(users)
    if num_users == 0 do
      GenServer.stop(server)
      Message.Supervisor.terminate_child(server)
      {:noreply, Map.delete(state, name)}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_call({:join, name, user}, _from, state) do
    if Map.has_key?(state, name) do
      ms = GenServer.call(state[name], {:join, user})
      {:reply, {state[name], ms}, state}
    else
      {:ok, pid} = Message.Supervisor.start_child(name)
      ms = GenServer.call(pid, {:join, user})
      {:reply, {pid, ms}, Map.put(state, name, pid)}
    end
  end

  @impl true
  def handle_call({:get, name}, _from, state) do
    {:reply, state[name], state}
  end

end
