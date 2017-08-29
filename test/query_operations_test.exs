defmodule QueryOperationsTest do
  use ExUnit.Case
  doctest QueryOperations

  import TransactionManager
  import QueryOperations

  test "delete a given simple key" do
    transact(&put/3, ["key","value"])
    transact(&delete/2, ["key"])
    assert transact(&get/2, ["key"]) == nil
  end

  test "delete a parent key to delete all its child" do
    transact(&put/3, ["key1.key2","value"])
    transact(&delete/2, ["key1"])
    assert transact(&get/2, ["key1.key2"]) == nil
  end

  test "delete an unavailable delete does not do anything" do
    transact(&delete/2, ["unavailable"])
  end

end
