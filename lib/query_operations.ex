defmodule QueryOperations do

  import TransformUtil

  def put(conn, key, value), do: Redix.command(conn, ["SET", key, value])

  def get(conn, key) do
    keys = keys(conn, key)
    values =
    case keys do
      [] -> nil
      _  ->  {:ok, vals} = Redix.pipeline(conn, piped_gets(keys))
              vals
    end
    merge_into_map(keys, values) |> deepen_map |> retrieve_for_dotted_key(key)
  end

  def delete(conn, key) do
    keys = keys(conn, key)
    case keys do
      [] -> IO.puts("Key Not Found")
      _ -> Redix.pipeline(conn, piped_dels(keys))
    end
  end

  defp keys(conn, key) do
    {:ok, keys} = Redix.pipeline(conn,[["KEYS", key],["KEYS",key<>".*"]])
    List.flatten(keys)
  end


  defp piped_gets(keys), do: piped_commands(keys,"GET")
  defp piped_dels(keys), do: piped_commands(keys,"DEL")

  defp piped_commands(keys, command), do: piped_commands(keys,command, [])
  defp piped_commands([], _, commands), do: commands
  defp piped_commands([head|tail], command, commands), do: piped_commands(tail,  command, commands ++[[command, head]])

end
