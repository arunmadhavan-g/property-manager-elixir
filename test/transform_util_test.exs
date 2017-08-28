defmodule TransformUtilTest do
  use ExUnit.Case
  doctest TransformUtil


  @doc """
    Tests for merge into map

    The functionality is to merge 2 lists into a map
  """
  test "for input of 2 lists with same size, get a merged map" do
    merged_map = TransformUtil.merge_into_map ["key1", "key2"], ["value1", "value2"]
    assert merged_map == %{"key1" => "value1", "key2" => "value2"}
  end
  
  test "for input of keys with more elements than values, get a marged map with the excess values filled with nil" do
    merged_map = TransformUtil.merge_into_map ["key1", "key2"], ["value1"]
    assert merged_map == %{"key1" => "value1", "key2" => nil}
  end

  test "for input of keys with lesser elements than values, the rest of the values are ignored" do
    merged_map = TransformUtil.merge_into_map ["key1"] , ["value1", "value2"]
    assert merged_map == %{"key1" => "value1"}
  end


  @doc """
    Tests for deepen map.

    the functionality takes a map with keys that have strings with "." (dots)
    converts that into deeper map.

    For example
    %{"k1.k2.k3" => "v"} will be transformed to %{"k1" => %{ "k2" => %{"k3" =>"v"}}}

  """

  test "for a map with simple K and V, return the same" do
    assert TransformUtil.deepen_map(%{"K"=> "V"}) == %{"K"=>"V"}
  end

  test "for a map with k1.k2 and v, get a single nested map" do
    assert TransformUtil.deepen_map(%{"k1.k2" => "v"}) == %{"k1" => %{"k2" => "v"}}
  end

  test "for a map with 2 keys, one that is simple and another dotted, get a map with 2 keys where the first is simple and dotted is nested" do
    assert TransformUtil.deepen_map(%{"k"=>"v", "k1.k2" => "v1"}) == %{"k" => "v", "k1" => %{"k2" => "v1"}}
  end

  test "for a dotted key 3 levels deep, get a map 3 levels nested" do
    assert TransformUtil.deepen_map(%{"k1.k2.k3" => "v"}) == %{"k1" => %{"k2" => %{"k3" => "v"}}}
  end

end
