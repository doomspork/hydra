defmodule Hydra.Routers.EndpointsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Hydra.{Endpoint, Error, Request, Routers.Endpoints}

  @opts Endpoints.init([])
  @json_mime "application/json"

  def request(:post, path, body) do
    :post
    |> conn(path, body)
    |> put_req_header("content-type", @json_mime)
    |> Endpoints.call(@opts)
  end

  test "dispatch new endpoint" do
    valid = %Endpoint{path: "/test", description: "a description", requests: [%Request{url: "http://www.example.com"}]}
            |> Poison.encode!

    conn = request(:post, "/", valid)
    assert conn.state == :sent
    assert conn.status == 201

    resp = Poison.decode!(conn.resp_body, as: Endpoint)
    assert resp.path == "/test"
    assert resp.description == "a description"
  end

  test "dispatch invalid new endpoint" do
    invalid = %{description: "", requests: []}
              |> Poison.encode!

    conn = request(:post, "/", invalid)
    assert conn.state == :sent
    assert conn.status == 400

    resp = Poison.decode!(conn.resp_body, as: Error)
    assert resp.code == 100
    assert resp.message == "Bad request.  Malformed or missing data"
  end
end
