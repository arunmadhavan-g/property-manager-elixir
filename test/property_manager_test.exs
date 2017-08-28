defmodule PropertyManagerTest do
  use ExUnit.Case
  doctest PropertyManager

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
    PropertyManager.put("key","value")
    assert PropertyManager.get("key") == "value"
  end

  test "store a single nested key value pair" do
    PropertyManager.put("key1",%{"key2" => "value"})
    assert PropertyManager.get("key1.key2") == "value"
  end

  test "get map for query of master key" do
    PropertyManager.put("key1",%{"key2" => "value"})
    assert  PropertyManager.get("key1") == %{"key2" => "value"}
  end

  test "add a value with nested key" do
    PropertyManager.put("key1.key3","nested Value")
    assert PropertyManager.get("key1") == %{"key3" => "nested Value"}
  end

end
