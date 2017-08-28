defmodule PropertyManager do

  import TransactionManager

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
    transact(&put/3, key, value)
  end

  def get(key), do: transact(&get/2, key, nil)

end


