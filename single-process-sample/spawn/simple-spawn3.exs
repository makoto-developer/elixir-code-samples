# n個のプロセスを生成し、1番目のプロセスは2番目のプロセスに+1して渡す。2番目のプロセスは3番目のプロセスに+1して...を繰り返す。
#
defmodule Chain do
  def counter(next_pid) do
    receive do
      n ->
        send next_pid, n + 1
    end
  end

  def create_processes(n) do
    code_to_run = fn (_, send_to) ->
      spawn(Chain, :counter, [send_to])
    end

    last = Enum.reduce(1..n, self(), code_to_run)
    send(last, 0)

    receive do
      final_answer when is_integer(final_answer) ->
        "Result is #{inspect(final_answer)}"
    end
  end

  def run(n) do
    :timer.tc(Chain, :create_processes, [n])
    |> IO.inspect
  end
end

## 検証1 いくつまでプロセスが作るか
# > elixir -r simple-spawn3.exs -e "Chain.run 10"
# {1659, "Result is 10"}
# > elixir -r simple-spawn3.exs -e "Chain.run 100"
# {1615, "Result is 100"}
# > elixir -r simple-spawn3.exs -e "Chain.run 1_000"
# {3825, "Result is 1000"}
# > elixir -r simple-spawn3.exs -e "Chain.run 10_000"
# {19268, "Result is 10000"}
# > elixir -r simple-spawn3.exs -e "Chain.run 100_000"
# {190158, "Result is 100000"}
# > elixir -r simple-spawn3.exs -e "Chain.run 1_000_000" # <---------------- デフォルトだと400,000個のプロセスまでしか作れない。
#
# 10:04:58.501 [error] Too many processes
#
#
# ** (SystemLimitError) a system limit has been reached
#     :erlang.spawn(Chain, :counter, [#PID<0.94.8>])
#     simple-spawn3.exs:11: anonymous fn/2 in Chain.create_processes/1
#     (elixir 1.13.3) lib/enum.ex:4136: Enum.reduce_range/5
#     simple-spawn3.exs:14: Chain.create_processes/1
#     (stdlib 3.17) timer.erl:197: :timer.tc/3
#     simple-spawn3.exs:24: Chain.run/1
#     (stdlib 3.17) erl_eval.erl:685: :erl_eval.do_apply/6

## 検証2 仮想マシンのプロセス上限を塗り替える
# > elixir --erl "+P 100000000" -r simple-spawn3.exs -e "Chain.run 1_000_000"
# {2395782, "Result is 1000000"}

# まとめると
# プロセスを10個作るのに2ミリ秒
# プロセスを100個作るのに2ミリ秒
# プロセスを1,000個作るのに4ミリ秒
# プロセスを10,000個作るのに20ミリ秒
# プロセスを100,000個作るのに200ミリ秒
# プロセスを1000,000個作るのに2.3秒

