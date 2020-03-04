defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    registryName = context.test
    registry = start_supervised!({KV.Registry, name: registryName})
    %{registry: registryName}
  end

  test "no buckets", %{registry: registry} do
    assert KV.Registry.search(registry, "shopping") == :error
  end

  test "buckets", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.search(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.search(registry, "shopping")
    Agent.stop(bucket)
    assert KV.Registry.search(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.search(registry, "shopping")

    Agent.stop(bucket, :shutdown)
    assert KV.Registry.search(registry, "shopping") == :error
  end
end
