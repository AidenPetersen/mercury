defmodule Mercury.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Mercury.Message.Supervisor, name: Supervisors.Message},
      {Mercury.Message.ServerMap, name: Supervisors.MessageMap},
      {Mercury.TCPSupervisor, []},
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
