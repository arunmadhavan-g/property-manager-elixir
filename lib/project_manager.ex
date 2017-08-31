defmodule ProjectManager do
  import StorageManager

  def projects(), do: get("project") |> String.split("~")

  def create(name), do:  append("project", available_name(name))

  defp available_name(name), do: projects() |> name_exists(name)

  defp name_exists([], name), do: name
  defp name_exists([head|_] , name) when head == name, do: raise "Project Unavailable"
  defp name_exists([_|tail], name), do: name_exists(tail, name)

end
