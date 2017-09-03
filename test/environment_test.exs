defmodule EnvironmentTest do
  use ExUnit.Case

  doctest Environment
  import StorageManager

  setup do
    put("proj1.env", "dev~qa")
    on_exit fn ->
      delete("proj1.env")
    end
  end

  test "fetch all available environments" do
    assert Environment.environments("proj1") == ["dev","qa"]
  end

  test "add an environment" do
    Environment.add(%Environment{project: "proj1",name: "prod"})
    assert Environment.environments("proj1") == ["dev", "qa","prod"]
  end

  test "add an environment that already exits raises exception" do
    try do
      Environment.add(%Environment{project: "proj1", name: "dev"})
      assert false
      rescue
        RuntimeError -> assert 1==1
    end
  end

#Add Group
#Add Key
#Clone all to others
#Clone specific key (list) to others


end
