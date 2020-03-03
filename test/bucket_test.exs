defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  test "empty store" do
    {:ok, bucket} = KV.Bucket.start_link()
    assert KV.Bucket.get(bucket, "milk") == nil
  end

  test "insert element in store" do
    {:ok, bucket} = KV.Bucket.start_link()

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end
end
