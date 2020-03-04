defmodule KV do
  use Application

  @impl true
  def start(_type, args) do
    IO.inspect args
    KV.Supervisor.start_link([])
  end
end
