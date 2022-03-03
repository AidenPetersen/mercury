defmodule Mercury.TCP.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(_init_args) do

    port = 4040

    children = [
      {Task.Supervisor, name: Mercury.TCP.ReceiverSupervisor},
      {Task, fn -> Mercury.TCP.Receiver.accept(port) end}
    ]
    opts = [strategy: :one_for_one]

    Supervisor.init(children, opts)
  end
end
