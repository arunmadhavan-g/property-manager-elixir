defmodule TransformUtil do

  def merge_into_map(keys, values), do: merge_into_map(keys, values, %{})
  defp merge_into_map([], _ , map), do: map
  defp merge_into_map([keyh|keyt], [], map), do: merge_into_map(keyt, [], Enum.into(map, %{ keyh => nil}))
  defp merge_into_map([keyh| keyt], [valueh|valuet], map), do: merge_into_map(keyt, valuet, Enum.into(map, %{ keyh => valueh}))


  def deepen_map(map) do
    keys = Map.keys(map)
    deepen_map(keys, map, %{})
  end

  defp deepen_map([], _, result), do: result
  defp deepen_map([key|tail], map, result) do
    value = map[key]
    deepen_map(tail, map, key |> nested_map(value)  |> Enum.into(result))
  end

  def nested_map(key, value) do
    keylets = String.split(key, ".")
    List.foldr(keylets, value, fn key, value -> %{key => value} end)
  end

  def retrieve_for_dotted_key(map, key), do: key |> String.split(".") |> List.foldl(map, fn (key, m) -> m[key] end)

end
