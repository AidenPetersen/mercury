defmodule MercuryTest do
  use ExUnit.Case
  doctest Mercury

  test "tests genserver" do
    {:ok, pid} = GenServer.start_link(MessageServer, %{messages: [], users: []})
    # User 1
    Task.async(fn ->
      GenServer.call(pid, :join)
      :timer.sleep(1)
      GenServer.cast(pid, {:send, "Hello world!"})
    end)
    message_task = Task.async(fn ->
      GenServer.call(pid, :join)
      receive do
	      {:message, m} -> m
         end
    end)
    message = Task.await(message_task)
    assert message == "Hello world!";
  end

  test "greets the world" do
    assert Mercury.hello() == :world
  end
end
