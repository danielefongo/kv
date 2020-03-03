defmodule KV.Registry do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def search(registry, name) do
    GenServer.call(registry, {:search, name})
  end

  def create(registry, name) do
    GenServer.cast(registry, {:create, name})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:create, name}, buckets) do
    if Map.has_key?(buckets, name) do
      {:ok, buckets}
    else
      {:ok, bucket} = KV.Bucket.start_link
      {:noreply, Map.put(buckets, name, bucket)}
    end
  end

  @impl true
  def handle_call({:search, name}, _, buckets) do
    {:reply, Map.fetch(buckets, name), buckets}
  end
end
