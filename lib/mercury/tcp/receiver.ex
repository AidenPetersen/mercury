defmodule Mercury.TCP.Receiver do
  alias Mercury.TCP.Utils, as: Utils
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  # Listens on socket
  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Mercury.TCP.ReceiverSupervisor, fn -> serve(client, :none) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end



  # Handles sending messages
  defp serve(socket, server) do
    message = Utils.read_line(socket)
    cond do
      # Joining a server
      String.starts_with?(message, "join") ->
        name = String.replace_prefix(message, "join", "") |> String.trim()
        {new_server, messages} = GenServer.call(Mercury.Message.ServerMap, {:join, name, socket})
        Enum.each(messages, &Utils.write_line(&1, socket))
        serve(socket, new_server)

      server == :none ->
        Utils.write_line("Please join a server first.\n", socket)
        serve(socket, server)

      String.starts_with?(message, "send") ->
        message_trimmed = message
          |> String.replace_prefix("send", "")
          |> String.trim()

        _ = GenServer.cast(server, {:send, message_trimmed <> "\n"})
        serve(socket, server)
      true -> serve(socket, server)
    end
  end
end
