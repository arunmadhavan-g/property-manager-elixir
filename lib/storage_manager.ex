defmodule StorageManager do

  import TransactionManager
  import QueryOperations

  defp put_till_empty([], _, _) do
  end

  defp put_till_empty([head|tail], key, value) do
    put(key<>"."<> head, value[head])
    put_till_empty(tail, key, value)
  end

  def put(key, value) when is_map(value) do
    put_till_empty(Map.keys(value), key, value)
  end

  def put(key, value) do
    transact(&put/3, [key, value])
  end

  def get(key), do: transact(&get/2, [key])

  def append(key, value) do
    original_val = get(key)
    case original_val do
      nil -> put(key, value)
      _ -> put(key, original_val<>"~"<>value)
    end
  end

  def delete(key) do
    transact(&delete/2, [key])
  end

end


