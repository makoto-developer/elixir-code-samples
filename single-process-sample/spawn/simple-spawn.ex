defmodule SimpleSpawn do
  def hello do
    receive do
      {sender, msg} ->
        send sender, {:ok, "hello, #{msg}"}
    end
  end
end

# クライアント
pid = spawn(SimpleSpawn, :hello, [])
send pid, {self(), "Spawn!"}

receive do
  {:ok, message} ->
    IO.puts(message)
end

# > iex
# Erlang/OTP 24 [erts-12.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]
#
# Interactive Elixir (1.13.3) - press Ctrl+C to exit (type h() ENTER for help)
# iex(1)>  c("simple-spawn.ex")
# hello, Spawn!
# [SimpleSpawn]
# iex(2)>
# nil
# iex(3)>