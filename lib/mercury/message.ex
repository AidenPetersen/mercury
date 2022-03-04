defmodule Mercury.Message do
  def send_message(server, message) do
     _ = GenServer.cast(server, {:send, message <> "\n"})
     :ok
  end

  def join_server(name, socket) do
    GenServer.call(Mercury.Message.ServerMap, {:join, name, socket})
  end

  def leave_server(name, socket) do
    GenServer.call(Mercury.Message.ServerMap, {:leave, name, socket})
  end
end
