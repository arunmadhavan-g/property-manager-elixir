defmodule TransformUtil do

  def merge_into_map(keys, values), do: merge_into_map keys, values, %{}
  def merge_into_map([],[], map), do: map
  def merge_into_map([keyh| keyt], [valueh|valuet], map), do: merge_into_map(keyt, valuet, deep_merge(map, %{ keyh => valueh}))


  def deepen_map(map) do
    keys = Map.keys(map)
    deepen_map(keys, map, %{})
  end

  defp deepen_map([], _, result), do: result
  defp deepen_map([key|tail], map, result) do
    value = map[key]
    deepen_map(tail, map, key |> nested_map(value)  |> deep_merge(result))
  end

  def deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  defp deep_resolve(_key, left = %{}, right = %{}) do
    deep_merge(left, right)
  end

  defp deep_resolve(_key, _left, right) do
    right
  end

  def nested_map(key, value) do
    keylets = String.split(key, ".")
    List.foldr(keylets, value, fn key, value -> %{key => value} end)
  end

  def retrieve_for_dotted_key(map, key), do: key |> String.split(".") |> List.foldl(map, fn (key, m) -> m[key] end)

end
