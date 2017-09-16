defmodule Environment do
  import StorageManager
  defstruct project: "", name: ""

  def environments(project), do: project_env_key(project)|> get() |> String.split("~")

  def new(%Environment{} = env), do: append(project_env_key(env), available_name(env))

  def add(%Environment{} =env, key, value), do: build_key(env, key) |> append(value)

  def read_value(%Environment{} = env, key), do: build_key(env, key) |> get()

  def promote(_, [], _), do: :ok
  def promote(%Environment{} = from, [head|tail], %Environment{} = to) do
      promote(from, head, to)
      promote(from , tail, to)
  end
  def promote(%Environment{} = from, key, %Environment{} = to), do: build_key(to, key)|> append(read_value(from, key))

  def remove(%Environment{} = env, key), do: build_key(env, key) |> delete()

  defp build_key(%Environment{} = env, key), do: Enum.join([env.project, env.name, key], ".")

  defp project_env_key(%Environment{} =env), do: project_env_key(env.project)
  defp project_env_key(project), do: project<>".env"

  defp available_name(%Environment{} =env), do: available_name(env.name, exists?(env))
  defp available_name(_, true), do: raise "Environment Unavailable"
  defp available_name(name, _), do: name

  defp exists?(%Environment{} = env), do: environments(env.project) |> Enum.any?(fn name-> env.name == name end)

end
