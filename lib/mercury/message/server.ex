defmodule Mercury.Message.Server do
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
  def handle_cast({:send, m}, %{messages: ms, users: us, name: n}) do
    # Sends the message to each client
    Enum.each(us, fn u -> Mercury.TCP.Utils.write_line(m, u) end)

    # Adds new message to state.
    {:noreply, %{messages: [m | ms], users: us, name: n}}
  end

  @impl true
  def handle_call({:join, user}, _from, %{messages: ms, users: us, name: n}) do
    # Adds user to state
    {:reply, ms, %{messages: ms, users: [user | us], name: n}}
  end

  @impl true
  def handle_call({:leave, user}, _from, %{messages: ms, users: us, name: n}) do
    # Removes user from state
    new_users = Enum.filter(us, fn u -> u != user end)
    {:noreply, %{messages: ms, users: new_users, name: n}}
  end

  @impl true
  def handle_call(:users, _from, %{messages: ms, users: us, name: n}) do

    {:reply, us, %{messages: ms, users: us, name: n}}
  end

  @impl true
  def handle_call(:name, _from, %{messages: ms, users: us, name: n}) do
    {:reply, n, %{messages: ms, users: us, name: n}}
  end

  @impl true
  def terminate(_reason, _state) do
    # TODO Save messages to database
  end

end
