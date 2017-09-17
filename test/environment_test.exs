defmodule EnvironmentTest do
  use ExUnit.Case

  doctest Environment
  import StorageManager

  setup do
    put("proj1.env", "dev~qa")
    on_exit fn ->
      delete("proj1")
    end
  end

  test "fetch all available environments" do
    assert Environment.environments("proj1") == ["dev","qa"]
  end

  test "add an environment" do
    Environment.new(%Environment{project: "proj1",name: "prod"})
    assert Environment.environments("proj1") == ["dev", "qa","prod"]
  end

  test "add an environment that already exits raises exception" do
    try do
      Environment.new(env_dev())
      assert false
      rescue
        RuntimeError -> assert 1==1
    end
  end

  test "add a simple key and value to an environment " do
    Environment.Key.add( env_dev() , "key1" ,"value1")
    assert Environment.Key.read(env_dev(), "key1") == "value1"
  end

  test "promote a key from one environment to another" do
    Environment.Key.add( env_dev() , "key1" ,"value1")
    assert Environment.Key.read(env_qa(), "key1") == nil

    Environment.Key.promote(env_dev(), "key1", env_qa())
    assert Environment.Key.read(env_qa(), "key1") == "value1"
  end

  test "promote a list of keys from one environment to another" do
    Environment.Key.add(env_dev(),"key1","value1")
    Environment.Key.add(env_dev(),"key2","value2")
    Environment.Key.add(env_dev(),"key3","value3")

    Environment.Key.promote(env_dev(), ["key1","key2"], env_qa())

    assert Environment.Key.read(env_qa(), "key1") == "value1"
    assert Environment.Key.read(env_qa(), "key2") == "value2"
    assert Environment.Key.read(env_qa(), "key3") == nil
  end

  test "remove a key" do
    Environment.Key.add(env_dev(),"key1","value1")
    assert Environment.Key.read(env_dev(), "key1") == "value1"

    Environment.Key.remove(env_dev(), "key1")
    assert Environment.Key.read(env_dev(), "key1") == nil
  end

  test "add a nested key, to an existing key, removed the parent value" do
    Environment.Key.add(env_dev(),"key1","value1")
    assert Environment.Key.read(env_dev(), "key1") == "value1"

    Environment.Key.add(env_dev(),"key1.key2","value2")
    assert Environment.Key.read(env_dev(), "key1") == %{"key2" => "value2"}
  end


  defp env_qa(), do: %Environment{project: "proj1", name: "qa"}
  defp env_dev(), do: %Environment{project: "proj1", name: "dev"}


#Add Group
#Clone all to others
#Clone specific key (list) to others


end
