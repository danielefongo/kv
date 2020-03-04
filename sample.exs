alias KV.Bucket, as: Bucket
alias KV.Registry, as: Registry
alias KV.Supervisor, as: Supervisore

Supervisore.start_link([])

Registry.create("shopping")
{:ok, bucket} = Registry.search("shopping")
Bucket.put(bucket, "key", "value")
Bucket.get(bucket, "key")

registry = :erlang.whereis KV.Registry

send registry, {:put, "text", "Hello world"}
