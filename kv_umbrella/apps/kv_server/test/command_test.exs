defmodule KVServer.CommandTest do
  use ExUnit.Case, async: true
  doctest KVServer.Command

  setup context do
    registryName = context.test
    registry = start_supervised!({KV.Registry, name: registryName})
    %{registry: registryName}
  end

  test "sample test to inject collaborator", %{registry: registryName} do
    KV.Registry.start_link(name: registryName)
    KVServer.Command.run({:create, "bucket"}, registryName)
    KVServer.Command.run({:put, "bucket", "key", "value"}, registryName)
    {:ok, value} = KVServer.Command.run({:get, "bucket", "key"}, registryName)

    assert value == "value\r\nOK\r\n"
  end
end
