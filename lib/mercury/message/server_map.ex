defmodule Mercury.Server.ServerMap do
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
  def handle_cast({:join, name}, state) do
    if Map.has_key?(state, name) do
      {:noreply, state}
    else
      {:ok, pid} = Supervisors.Message.start_child(name)
      {:noreply, Map.put(state, name, pid)}
    end
  end

  @impl true
  def handle_cast({:leave, name}, state) do

    {:ok, users} = GenServer.call(Supervisor.Message, {:get})
    num_users = length(users)
    if num_users == 0 do
      {:ok, users} = GenServer.call(Supervisor.Message, {:leave})

    end

    Map.delete(state, name)
  end

  @impl true
  def handle_call(:get, {name, _info}, state) do
    {:reply, state[name], state}
  end

end
