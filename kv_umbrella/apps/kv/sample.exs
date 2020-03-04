alias KV.Bucket, as: Bucket
alias KV.Registry, as: Registry

Registry.create(KV.Registry, "shopping")
{:ok, bucket} = Registry.search(KV.Registry, "shopping")
Bucket.put(bucket, "key", "value")
IO.puts Bucket.get(bucket, "key")

registry = :erlang.whereis KV.Registry

send registry, {:put, "text", "Hello world"}
