defmodule StorageManagerTest do
  use ExUnit.Case
  doctest StorageManager

  defp testKeys, do: ["key",
                      "key1",
                      "key1.key2",
                      "key1.key3"]

  defp piped_dels(keys), do: piped_dels(keys,[])
  defp piped_dels([], gets), do: gets
  defp piped_dels([head|tail], gets), do: piped_dels(tail,  gets ++[["DEL", head]])

  setup do
    on_exit fn->
      {:ok, conn}= Redix.start_link()
      Redix.pipeline(conn, testKeys() |> piped_dels)
      Redix.stop(conn)
    end
  end

  test "store a simple key value pair" do
    StorageManager.put("key","value")
    assert StorageManager.get("key") == "value"
  end

  test "store a single nested key value pair" do
    StorageManager.put("key1",%{"key2" => "value"})
    assert StorageManager.get("key1.key2") == "value"
  end

  test "get map for query of master key" do
    StorageManager.put("key1",%{"key2" => "value"})
    assert  StorageManager.get("key1") == %{"key2" => "value"}
  end

  test "add a value with nested key" do
    StorageManager.put("key1.key3","nested Value")
    assert StorageManager.get("key1") == %{"key3" => "nested Value"}
  end

  test "get a key that is not available gives nil" do
    assert StorageManager.get("unavailable") == nil
  end

  test "append value to an existing key with ~ separation" do
    StorageManager.put("key", "val1")
    StorageManager.append("key", "val2")
    assert StorageManager.get("key") == "val1~val2"
  end

  test "append value to a new key will just put the value" do
    StorageManager.append("key","value")
    assert StorageManager.get("key") == "value"
  end

end
