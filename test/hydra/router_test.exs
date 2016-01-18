defmodule Hydra.RouterTest do
  use ExUnit.Case, async: false
  use Plug.Test

  alias Hydra.{Request, Route, Router, Storage}

  @opts Router.init([])
  @json_mime "application/json"

  defmodule ExampleRouter do
    use Plug.Router
    plug Plug.Parsers, parsers: [:urlencoded, :json],
                       pass:  ["text/*"],
                       json_decoder: Poison
    plug :match
    plug :dispatch

    get "/foo/:id" do
      send_resp(conn, 200, Poison.encode!([%{foo: String.to_integer(id)}]))
    end

    get "/bar" do
      send_resp(conn, 200, Poison.encode!([%{foo: "foo"}, %{bar: 42}]))
    end
  end

  setup_all do
    foo = %Request{url: "http://localhost:9999/foo/1", resp_filter: ".[0]"}
    bar = %Request{url: "http://localhost:9999/bar", resp_filter: ".[1]"}

    :hydra
    |> Application.get_env(:storage)
    |> Keyword.get(:name)
    |> Storage.insert(%Route{method: :get, path: "/dynamic", requests: [foo, bar]})

    Application.put_env(:hydra, :running, true)
    Code.load_file("lib/hydra/router.ex")

    {:ok, pid} = Plug.Adapters.Cowboy.http(ExampleRouter, [], [port: 9999])

    on_exit fn ->
      Plug.Adapters.Cowboy.shutdown(pid)
    end

    :ok
  end

  def request(:get, path) do
    :get
    |> conn(path)
    |> put_req_header("content-type", @json_mime)
    |> Router.call(@opts)
  end

  test "dispatch root" do
    conn = request(:get, "/")
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hi."
  end

  test "dispatch missing" do
    conn = request(:get, "/unknown")
    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Oops!"
  end

  test "dispatch dynamic route" do
    conn = request(:get, "/dynamic")
    assert conn.state == :sent
    assert conn.status == 200

    assert %{"foo" => 1, "bar" => 42} == Poison.decode!(conn.resp_body)
  end
end
