defmodule Mercury.Message.Helpers do
  def join_channel(name) do
    _ = GenServer.cast(Supervisors.MessageMap, {:join, name})
    {:ok, pid} = GenServer.call(Supervisor.Message, {:get})

  end

  def send_message(pid, message) do
    GenServer.cast(pid, {:send, message})
  end
end
