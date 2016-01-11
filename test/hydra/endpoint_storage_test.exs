defmodule Hydra.EndpointStorageTest do
  use ExUnit.Case, async: true

  alias Hydra.{Endpoint, EndpointStorage}

  test "basic functionality" do
    endpoint = %Endpoint{path: "/test", description: "A test"}

    assert nil == EndpointStorage.lookup("/test")

    EndpointStorage.register(endpoint)

    route = EndpointStorage.lookup("/test")
    assert %Endpoint{} = route

    assert EndpointStorage.lookup("/another") == nil
  end
end
