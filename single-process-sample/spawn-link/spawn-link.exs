defmodule Link do
  import :timer, only: [ sleep: 1 ]
  def send_function do
    sleep 500
    exit(:finished)
  end

  def run do
    Process.flag(:trap_exit, true)
    spawn_link(Link, :send_function, [])
    receive do
      message ->
        IO.puts("message is #{inspect(message)}}")
    after 2000 ->
      IO.puts("no messages")
    end
  end
end

Link.run