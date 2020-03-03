defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    %{bucket: bucket}
  end

  test "empty store", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil
  end

  test "insert element in store", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end
end
