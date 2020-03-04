alias KV.Bucket, as: Bucket
alias KV.Registry, as: Registry

Registry.create("shopping")
{:ok, bucket} = Registry.search("shopping")
Bucket.put(bucket, "key", "value")
Bucket.get(bucket, "key")

registry = :erlang.whereis KV.Registry

send registry, {:put, "text", "Hello world"}
