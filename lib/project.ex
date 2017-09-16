defmodule Project do
  import StorageManager

  def projects() do
    project_str = get("project")
    case project_str do
      nil -> []
      _ -> String.split(project_str,"~")
    end
  end

  def exists?(name), do: Enum.any?(projects(), fn proj-> proj==name end)

  def create(name), do:  append("project", available_name(name))


  defp available_name(name), do: available_name(name, exists?(name))
  defp available_name(_, exists) when exists, do: raise "Project Unavailable"
  defp available_name(name, _), do: name


end
