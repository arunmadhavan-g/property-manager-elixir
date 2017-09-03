defmodule ProjectManager do
  import StorageManager

  def projects(), do: get("project") |> String.split("~")

  def exists?(name), do: Enum.any?(projects(), fn proj-> proj==name end)

  def create(name), do:  append("project", available_name(name))


  defp available_name(name), do: available_name(name, exists?(name))
  defp available_name(_, exists) when exists, do: raise "Project Unavailable"
  defp available_name(name, _), do: name


end
