defmodule Mercury.Message.ServerMap do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(init_state) do
    {:ok, init_state}
  end

  @impl true
  def handle_call({:join, name, user}, _from, state) do
    if Map.has_key?(state, name) do
      ms = GenServer.call(state[name], {:join, user})
      {:reply, {state[name], ms}, state}
    else
      {:ok, pid} = Mercury.Message.Supervisor.start_child(name)
      ms = GenServer.call(pid, {:join, user})
      {:reply, {pid, ms}, Map.put(state, name, pid)}
    end
  end

  @impl true
  def handle_call({:leave, name, user}, _from, state) do
    GenServer.call(Supervisor.Message, {:join, user})
    GenServer.call(Supervisor.Message, :leave)
    users = GenServer.call(Supervisor.Message, :users)
    num_users = length(users)
    if num_users == 0 do
      GenServer.stop(state[name])
      {:noreply, Map.delete(state, name)}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_call({:get, name}, _from, state) do
    {:reply, state[name], state}
  end

end
