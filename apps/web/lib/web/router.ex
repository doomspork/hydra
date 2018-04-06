defmodule Web.Router do
  @moduledoc """
  The web interface for the Hydra gateway.
  Here requests are routed to either the admin endpoint or to our dynamic routing.
  """

  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json], pass: ["text/*"], json_decoder: Poison
  plug Web.Cache
  plug :dispatch

  get "/" do
    send_resp(conn, 200, Poison.encode!(%{msg: "hi"}))
  end

  get _ do
    conn
    |> pipeline()
    |> response(conn)
  end

  match _ do
    body = Poison.encode!(%{errors: ["unable to handle request at the requested path"]})
    send_resp(conn, 404, body)
  end

  defp cache?(conn), do: :no_caching not in conn.private[:hydra_cache]

  defp pipeline(%{req_headers: headers, request_path: path}) do
    Pipeline.run(path, headers)
  end

  defp response({:error, reason}, conn) do
    send_resp(conn, 500, Poison.encode!(%{errors: [reason]}))
  end

  defp response({:ok, resp}, %{request_path: request_path} = conn) do
    json_response = Poison.encode!(resp)

    if cache?(conn) do
      Storage.Cache.put(:responses, request_path, json_response)
    end

    send_resp(conn, 200, json_response)
  end
end
