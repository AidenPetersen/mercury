defmodule Mercury.Supervisor do
  use Supervisor
  alias Mercury.Server.MessageSupervisor, as: MessageSupervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    children = [
      {MessageSupervisor, [strategy: :one_for_one]}
    ]

    Supervisor.init(children, init_arg)
  end
end
