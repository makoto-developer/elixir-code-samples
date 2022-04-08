defmodule Worker do
  def random do
    :rand.uniform(1000)
  end

  def sleep(n) do
    IO.puts "sleep(#{inspect n}) started."
    :timer.sleep(n)
    IO.puts "sleep(#{inspect n}) ended."
    "result-sleep(#{inspect n})"
  end

  # time elixir -e Worker.exec_seq
  def exec_seq do
    IO.puts "===== 逐次実行開始 ====="
    result = 1 .. 100
             |> Enum.map(fn(_) -> random() end)
             |> Enum.map(fn(t) -> Worker.sleep(t) end)

    IO.puts "===== 逐次実行結果 ====="
    result
  end

  # time elixir -e Worker.exec_con
  def exec_con do
  IO.puts "===== 並行実行開始 ====="
  result = 1 .. 100
           |> Enum.map(fn(_) -> random() end)
           |> Enum.map(fn(t) -> Task.async(Worker, :sleep, [t]) end)
           |> Enum.map(fn(d) -> Task.await(d) end)

  IO.puts "===== 並行実行結果 ====="
  result
  end
end

