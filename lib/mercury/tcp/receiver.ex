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
  defp serve(socket, server_name) do
    case Utils.read_line(socket) do
      {:ok, message} ->
        cond do
          # Joining a server
          String.starts_with?(message, "join") ->
            if server_name != :none do
              Message.leave_server(server_name, socket)
            end
            name = String.replace_prefix(message, "join", "") |> String.trim()
            messages = Message.join_server(name, socket)
            Enum.each(messages, &Utils.write_line(&1, socket))
            serve(socket, name)

          server_name == :none ->
            Utils.write_line("Please join a server first.\n", socket)
            serve(socket, server_name)

          String.starts_with?(message, "send") ->
            message_trimmed =
              message
              |> String.replace_prefix("send", "")
              |> String.trim()

            Message.send_message(server_name, message_trimmed)
            serve(socket, server_name)

          true ->
            serve(socket, server_name)
        end
      {:error, :closed} ->
        handle_close(socket, server_name)
    end
  end
  defp handle_close(socket, server_name) when server_name != :none do
    _ = Message.leave_server(server_name, socket)
    :ok
  end

  defp handle_close(_socket, :none) do
    :ok
  end

end
