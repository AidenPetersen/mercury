defmodule Mercury.TCP.Receiver do
  alias Mercury.TCP.Utils
  alias Mercury.Message
  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  # Listens on socket
  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} =
      Task.Supervisor.start_child(Mercury.TCP.ReceiverSupervisor, fn -> serve(client, :none) end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  # Handles sending messages
  defp serve(socket, server) do
    case Utils.read_line(socket) do
      {:ok, message} ->
        cond do
          # Joining a server
          String.starts_with?(message, "join") ->
            name = String.replace_prefix(message, "join", "") |> String.trim()

            {new_server, messages} = Message.join_server(name, socket)
            Enum.each(messages, &Utils.write_line(&1, socket))
            serve(socket, new_server)

          server == :none ->
            Utils.write_line("Please join a server first.\n", socket)
            serve(socket, server)

          String.starts_with?(message, "send") ->
            message_trimmed =
              message
              |> String.replace_prefix("send", "")
              |> String.trim()

            Message.send_message(server, message_trimmed)
            serve(socket, server)

          true ->
            serve(socket, server)
        end
      {:error, :closed} ->
        handle_close(socket, server)
    end
  end
  defp handle_close(socket, server) when server != :none do
    _ = Message.leave_server(socket, server)
    :ok
  end

  defp handle_close(_socket, :none) do
    :ok
  end

end
