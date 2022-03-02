defmodule Mercury.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Mercury.Server.MessageSupervisor, []},
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
