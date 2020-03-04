defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    start_supervised!(KV.Registry)
    :ok
  end

  test "no buckets" do
    assert KV.Registry.search("shopping") == :error
  end

  test "buckets" do
    KV.Registry.create("shopping")
    assert {:ok, bucket} = KV.Registry.search("shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit" do
    KV.Registry.create("shopping")
    {:ok, bucket} = KV.Registry.search("shopping")
    Agent.stop(bucket)
    assert KV.Registry.search("shopping") == :error
  end

  test "removes bucket on crash" do
    KV.Registry.create("shopping")
    {:ok, bucket} = KV.Registry.search("shopping")

    Agent.stop(bucket, :shutdown)
    assert KV.Registry.search("shopping") == :error
  end
end
