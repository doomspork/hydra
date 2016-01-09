defmodule Hydra.DynamicEndpoints do
  @moduledoc """
  A Plug to handle our dynamic endpoints
  """

  import Plug.Conn

  alias Hydra.{Endpoint, EndpointStorage, RequestPipeline}
  alias Plug.Conn

  def init(options), do: options

  def call(%Conn{method: "GET", request_path: path} = conn, _opts) do
    case EndpointStorage.lookup(path) do
      nil -> conn
      endpoint -> call_endpoint(conn, endpoint)
    end
  end
  def call(conn, _opts), do: conn

  defp aggregate_requests([], result), do: result
  defp aggregate_requests([task|tasks], result) do
    case Task.yield(task, 1000) do
      {:ok, reply} -> result = Map.merge(result, reply)
      nil -> tasks = [tasks|task]
    end
    aggregate_requests(tasks, result)
  end

  defp call_endpoint(conn, %Endpoint{requests: requests}) do
    requests
    |> Enum.map(fn (req) -> RequestPipeline.async_start(req) end)
    |> aggregate_requests(%{})
    |> send_aggregate_resp(conn)
  end

  defp send_aggregate_resp(body, conn) do
    json = Poison.encode!(body)
    send_resp(conn, 200, json)
  end
end
