defmodule ProjectManagerTest do
  use ExUnit.Case

  doctest ProjectManager
  import StorageManager

  setup do
    on_exit fn->
      delete("project")
    end
  end

  test "get the list of projects" do
    put("project","proj1~proj2")
    assert ProjectManager.projects() == ["proj1","proj2"]
  end

  test "add a new project" do
    StorageManager.put("project","proj1~proj2")
    ProjectManager.create("proj3")
    assert ProjectManager.projects == ["proj1","proj2","proj3"]
  end

  test "add a new project with existing name leads to runtime error" do
    StorageManager.put("project" ,"proj1~proj2")
    try do
      ProjectManager.create("proj2")
      assert false
    rescue
      RuntimeError -> assert 1==1
    end
  end

end
