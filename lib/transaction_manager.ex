defmodule TransactionManager do

  import TransformUtil

  def transact(operation, key, value) do
    {:ok, conn}= Redix.start_link()
    return =
      case(:erlang.fun_info(operation)[:arity]) do
        3-> operation.(conn, key, value)
        2-> operation.(conn, key)
      end
    Redix.stop(conn)
    return
  end

  def put(conn, key, value), do: Redix.command(conn, ["SET", key, value])

  def get(conn, key) do
    keys = keys(conn, key)
    {:ok, values} = Redix.pipeline(conn, piped_gets(keys))
    merge_into_map(keys, values) |> deepen_map |> retrieve_for_dotted_key(key)
  end


  defp keys(conn, key) do
    {:ok, keys} = Redix.pipeline(conn,[["KEYS", key],["KEYS",key<>".*"]])
    List.flatten(keys)
  end

  defp piped_gets(keys), do: piped_gets(keys,[])
  defp piped_gets([], gets), do: gets
  defp piped_gets([head|tail], gets), do: piped_gets(tail,  gets ++[["GET", head]])


end
