defmodule Environment do
  import StorageManager
  defstruct project: "", name: ""

  def environments(project), do: project_env_key(project)|> get() |> String.split("~")

  def add(%Environment{} = env), do: append(project_env_key(env), available_name(env))

  defp project_env_key(%Environment{} =env), do: project_env_key(env.project)
  defp project_env_key(project), do: project<>".env"

  defp available_name(%Environment{} =env), do: available_name(env.name, exists?(env))
  defp available_name(_, true), do: raise "Environment Unavailable"
  defp available_name(name, _), do: name

  defp exists?(%Environment{} = env), do: environments(env.project) |> Enum.any?(fn name-> env.name == name end)

end
