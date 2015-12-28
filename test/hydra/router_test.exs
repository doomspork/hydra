defmodule Hydra.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Hydra.Router

  @opts Router.init([])
  @json_mime "application/json"

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
end
