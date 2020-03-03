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
    buckets = %{}
    refs = %{}
    {:ok, {buckets, refs}}
  end

  @impl true
  def handle_cast({:create, name}, {buckets, refs}) do
    if Map.has_key?(buckets, name) do
      {:noreply, {buckets, refs}}
    else
      {:ok, bucket} = KV.Bucket.start_link
      buckets = Map.put(buckets, name, bucket)
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      {:noreply, {buckets, refs}}
    end
  end

  @impl true
  def handle_call({:search, name}, _, state) do
    {buckets, _} = state
    {:reply, Map.fetch(buckets, name), state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _, _}, {buckets, refs}) do
    {bucket, refs} = Map.pop(refs, ref)
    buckets = Map.delete(buckets, bucket)
    {:noreply, {buckets, refs}}
  end

  @impl true
  def handle_info(_, state), do: {:noreply, state}
end
