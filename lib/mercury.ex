defmodule Mercury.Application do
  use Application

  @impl true
  def start(_type, _args) do

    opts = [strategy: :one_for_one, name: Mercury.Server.MessageSupervisor]
    DynamicSupervisor.start_link(opts)

  end
end
