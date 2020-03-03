defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
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
end
