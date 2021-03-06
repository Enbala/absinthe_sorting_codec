defmodule AbsintheSortingCodecTest do
  @introspection_graphql Path.join([:code.priv_dir(:absinthe), "graphql", "introspection.graphql"])

  def introspection_graphql, do: @introspection_graphql

  use ExUnit.Case

  test "it encodes a root query" do
    assert run(TestQuerySchema) == json_fixture("test_query_schema.json")
  end

  test "it encodes a mutation" do
    assert run(TestMutationSchema) == json_fixture("test_mutation_schema.json")
  end

  test "it encodes a subscription" do
    assert run(TestSubscriptionSchema) == json_fixture("test_subscription_schema.json")
  end

  test "it encodes an introspection query" do
    actual = sorted_json_fixture("swapi.json")
    expected = file_fixture("test_swapi.json")
    assert actual == expected
  end

  def file_fixture(file) do
    File.read!("test/fixtures/json/" <> file)
  end

  def json_fixture(file) do
    File.read!("test/fixtures/json/" <> file) |> Jason.decode!()
  end

  def sorted_json_fixture(file) do
    file
    |> json_fixture()
    |> AbsintheSortingCodec.encode!(pretty: true)
    |> Kernel.<>("\n")
  end

  def run(schema) do
    {:ok, query} = File.read(@introspection_graphql)
    {:ok, result} = Absinthe.run(query, schema)

    result
    |> AbsintheSortingCodec.encode!(pretty: true)
    |> Jason.decode!()
  end
end
