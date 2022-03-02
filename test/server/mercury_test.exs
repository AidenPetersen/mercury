defmodule Mercury.Server.ServerTest do
  use ExUnit.Case

  test "tests genserver" do
    {:ok, pid} = GenServer.start_link(Mercury.Server.MessageServer, %{messages: [], users: []})
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
