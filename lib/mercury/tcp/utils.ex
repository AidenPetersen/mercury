defmodule Mercury.TCP.Utils do
  def read_line(socket) do
    :gen_tcp.recv(socket, 0)

  end

  def write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
