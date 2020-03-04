defmodule KV.Registry do
  use GenServer

  def start_link(opts) do
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  def search(registry, name) do
    case :ets.lookup(registry, name) do
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end
  end

  def create(registry, name) do
    GenServer.call(registry, {:create, name})
  end

  @impl true
  def init(serverName) do
    refs = %{}
    buckets = :ets.new(serverName, [:named_table, read_concurrency: true])
    {:ok, {buckets, refs}}
  end

  @impl true
  def handle_call({:create, name}, _from, {buckets, refs}) do
    case search(buckets, name) do
      {:ok, pid} -> {:reply, pid, {buckets, refs}}
      :error ->
        {:ok, bucketPid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        ref = Process.monitor(bucketPid)
        refs = Map.put(refs, ref, name)
        :ets.insert(buckets, {name, bucketPid})
        {:reply, bucketPid, {buckets, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _, _}, {buckets, refs}) do
    {bucket, refs} = Map.pop(refs, ref)
    :ets.delete(buckets, bucket)
    {:noreply, {buckets, refs}}
  end

  @impl true
  def handle_info(_msg, state), do: {:noreply, state}
end
