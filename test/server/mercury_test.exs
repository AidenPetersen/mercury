defmodule Mercury.Server.ServerTest do
  use ExUnit.Case
  alias Mercury.Server.MessageServer, as: MessageServer
  alias Mercury.Server.MessageSupervisor, as: MessageSupervisor

  test "test genserver" do
    {:ok, pid} = MessageSupervisor.start_child("test")

    # User 1
    Task.async(fn ->
      GenServer.call(pid, :join)
      :timer.sleep(1)
      GenServer.cast(pid, {:send, "Hello world!"})
    end)
    # User 2
    message_task = Task.async(fn ->
      GenServer.call(pid, :join)
      receive do
        {:message, m} -> m
         end
    end)
    message = Task.await(message_task)
    assert message == "Hello world!";
  end
end
