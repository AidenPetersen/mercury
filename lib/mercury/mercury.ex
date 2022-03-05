defmodule Mercury.Application do
  use Application

  @impl true
  def start(_type, _args) do

    children = [
      Mercury.Message.Supervisor,
      Mercury.Message.ServerMap,
      Mercury.TCP.Supervisor,
    ]

    opts = [strategy: :one_for_one, name: Mercury.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
