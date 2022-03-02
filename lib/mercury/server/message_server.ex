defmodule Mercury.Server.MessageServer do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(%{messages: ms, users: us, name: n}) do
    {:ok, %{messages: ms, users: us, name: n}}
  end

  @impl true
  def handle_cast({:send, m}, %{messages: ms, users: us}) do
    # Sends the message to each client
    Enum.each(us, fn u -> send(u, {:message, m}) end)

    # Adds new message to state.
    {:noreply, %{messages: [m | ms], users: us}}
  end

  @impl true
  def handle_call(:join, {pid, _info}, %{messages: ms, users: us}) do
    # Adds user to state
    {:reply, ms, %{messages: ms, users: [pid | us]}}
  end

  @impl true
  def handle_call(:leave, from, %{messages: ms, users: us}) do

    # Removes user from state
    new_users = Enum.filter(us, fn u -> u.pid != from.pid end)
    {:reply, ms, %{messages: ms, users: new_users}}
  end

  @impl true
  def handle_call(:users, _from, %{messages: ms, users: us}) do

    {:reply, us, %{messages: ms, users: us}}
  end

end