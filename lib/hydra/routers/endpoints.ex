defmodule Hydra.Routers.Endpoints do
  @moduledoc """
  Plug Router for Endpoint management
  """

  use Plug.Router

  alias Hydra.{Endpoint, EndpointStorage, Error, Request}
  alias Plug.Conn

  @endpoint_fields ["path", "description", "requests"]
  @request_fields ["url"]

  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass:  ["text/*"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  post "/", do: create_endpoint(conn)

  match _, do: send_resp(conn, 404, "oops")

  defp create_endpoint(%Conn{body_params: params} = conn) do
    if request_valid?(params) do
      json = params
             |> new_endpoint
             |> EndpointStorage.register
             |> Poison.encode!

      send_resp(conn, 201, json)
    else
      send_resp(conn, 400, invalid_request_error)
    end
  end

  defp invalid_request_error, do: 100 |> Error.get_error |> Poison.encode!

  defp new_endpoint(params) do
    reqs = params
           |> Map.get("requests")
           |> Enum.map(fn (req) -> new_struct(req, Request) end)

    params
    |> Map.put("requests", reqs)
    |> new_struct(Endpoint)
  end

  defp new_struct(values, type) when is_map(values) do
    values
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> new_struct(type)
  end
  defp new_struct(values, type) do
    struct(type, values)
  end

  defp request_valid?(params) do
    reqs = Map.get(params, "request", [])
    !Enum.empty?(reqs) || (valid_endpoint?(params) && Enum.all?(reqs, &valid_request?/1))
  end

  defp valid_endpoint?(params), do: validate(params, @endpoint_fields)
  defp valid_request?(params), do: validate(params, @request_fields)

  defp validate(params, fields) do
    params
    |> Map.keys
    |> valid_fields?(fields)
  end

  defp valid_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))
end
