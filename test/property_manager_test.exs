defmodule PropertyManagerTest do
  use ExUnit.Case
  doctest PropertyManager

  @doc """

    what do we need?

    a propertt manager that helps store and retrieve stuffs.

    First of all we need to store stuffs in a K-V pair, this can be nested too.

    So retrieve the V for a given K

    1. store a K and V
    2. Retrieve the V for a K
    3. store a nested K and V
    4. Retrieve V for a K1.K2 ...
    5. Retrieve V => a nexted map

    6. Get all this as  a json response.
    { key:"bla" , value:"{ key:...}"

    When we talk about store, we mean in an actual DB ( Redis in this case)

  """

  test "store a simple key value pair" do
    PropertyManager.put("key","value")
    assert PropertyManager.get("key") == "value"
  end

  test "store a single nested key value pair" do
    PropertyManager.put("key1",%{"key2": "value"})
    assert PropertyManager.get("key1.key2") == "value"
  end

  test "get map for query of master key" do
    PropertyManager.put("key1",%{"key2": "value"})
    assert PropertyManager.get("key1") == %{"key2" => "value", "key3" => "nested Value"}
  end

  test "add a value with nested key" do
    PropertyManager.put("key1.key3","nested Value")
    assert PropertyManager.get("key1") == %{"key2" => "value", "key3" => "nested Value"}
  end

end
