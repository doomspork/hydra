defmodule Hydra.Routers.Endpoints do
  @moduledoc """
  Plug Router for Endpoint management
  """

  use Plug.Router

  alias Hydra.Endpoint
  alias Hydra.Error
  alias Plug.Conn

  @required_fields ["path", "description", "requests"]

  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass:  ["text/*"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  post "/", do: create_endpoint(conn)

  match _, do: send_resp(conn, 404, "oops")

  defp create_endpoint(%Conn{body_params: params} = conn) do
    if validate_endpoint(params) do
      endpoint = params
                 |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
                 |> new_endpoint

      EndpointStorage.register(endpoint)

      json = Poison.encode!(endpoint)
      send_resp(conn, 201, json)
    else

      error = 100
              |> Error.get_error
              |> Poison.encode!

      send_resp(conn, 400, error)
    end
  end

  defp new_endpoint(values), do: struct(Endpoint, values)

  defp validate_endpoint(params) do
    params
    |> Map.keys
    |> has_fields?
  end

  defp has_fields?(keys), do: Enum.all?(@required_fields, &(&1 in keys))
end

