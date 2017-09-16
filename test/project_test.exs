defmodule ProjectTest do
  use ExUnit.Case

  doctest Project
  import StorageManager

  setup do
    on_exit fn->
      delete("project")
    end
  end

  test "get the list of projects" do
    put("project","proj1~proj2")
    assert Project.projects() == ["proj1","proj2"]
  end

  test "add a new project for the very first time" do
    Project.create("proj1")
    assert Project.projects == ["proj1"]
  end

  test "add a new project" do
    StorageManager.put("project","proj1~proj2")
    Project.create("proj3")
    assert Project.projects == ["proj1","proj2","proj3"]
  end

  test "add a new project with existing name leads to runtime error" do
    StorageManager.put("project" ,"proj1~proj2")
    try do
      Project.create("proj2")
      assert false
    rescue
      RuntimeError -> assert 1==1
    end
  end

end
