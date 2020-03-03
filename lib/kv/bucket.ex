defmodule KV.Bucket do
  use Agent

  def start_link() do
    Agent.start(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @spec put(any, any, any) :: :ok
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end
end
