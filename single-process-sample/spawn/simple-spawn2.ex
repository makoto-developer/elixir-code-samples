# 複数のメッセージ処理

defmodule SimpleSpawn2 do
  def hello do
    receive do
      {sender, msg} ->
        send sender, {:ok, "hello, #{msg}"}
        # 再帰にしてメッセージを何回でも受信できるようにする
        hello()
    end
  end
end

# クライアント
pid = spawn(SimpleSpawn2, :hello, [])
send pid, {self(), "Spawn!"}

receive do
  {:ok, message} ->
    # 結果を待つ
    IO.puts("1 result #{message}")
end

send pid, {self(), "Alice!"}
receive do
  {:ok, message} ->
    IO.puts("2 result #{message}}")
  after 500 ->
    IO.puts("hello has done away")
end

# > iex
# Erlang/OTP 24 [erts-12.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]
#
# Interactive Elixir (1.13.3) - press Ctrl+C to exit (type h() ENTER for help)
# iex(1)> c("simple-spawn2.ex")
# hello, Spawn!
# hello, Alice!
# [SimpleSpawn2]
