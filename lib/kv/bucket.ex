defmodule KV.Bucket do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @spec put(any, any, any) :: :ok
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
