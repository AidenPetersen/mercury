defmodule Mercury.Server.MessageSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(name) do
    # TODO Query database for initial state of messages
    server_state = {Mercury.Server.MessageServer, %{messages: [], users: [], name: name}}
    DynamicSupervisor.start_child(__MODULE__, server_state)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
