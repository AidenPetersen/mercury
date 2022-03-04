defmodule Mercury.Message do
  def send_message(server_name, message) do
    server = GenServer.call(Mercury.Message.ServerMap, {:get, server_name})
     _ = GenServer.cast(server, {:send, message <> "\n"})
     :ok
  end

  def join_server(server_name, socket) do
    {_server, messages} = GenServer.call(Mercury.Message.ServerMap, {:join, server_name, socket})
    messages
  end

  def leave_server(server_name, socket) do
    GenServer.cast(Mercury.Message.ServerMap, {:leave, server_name, socket})
  end
end
