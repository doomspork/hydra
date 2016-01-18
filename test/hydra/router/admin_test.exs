defmodule Hydra.Routers.AdminTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Hydra.{Route, Error, Request, Router.Admin}

  @opts Admin.init([])
  @json_mime "application/json"

  def request(:post, path, body) do
    :post
    |> conn(path, body)
    |> put_req_header("content-type", @json_mime)
    |> Admin.call(@opts)
  end

  test "dispatch new endpoint" do
    requests = [%Request{url: "http://www.example.com"}]
    valid = %Route{method: :get, path: "/test", description: "a description", requests: requests}
            |> Poison.encode!

    conn = request(:post, "/", valid)
    assert conn.state == :sent
    assert conn.status == 201

    resp = Poison.decode!(conn.resp_body, as: Route)
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
