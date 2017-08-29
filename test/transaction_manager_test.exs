defmodule TransactionManagerTest do
  use ExUnit.Case
  doctest TransactionManager

  import QueryOperations

  setup do
    on_exit fn->
      {:ok, conn}= Redix.start_link()
      Redix.command(conn, ["SET", "testkey","value"])
      Redix.stop(conn)
    end
  end

  test "transaction happens for get" do
    TransactionManager.transact(&get/2, ["testkey"])
  end

  test "transaction happens for put" do
    TransactionManager.transact(&put/3, ["key", "value"])
    assert TransactionManager.transact(&get/2,["key"]) == "value"
  end


end
