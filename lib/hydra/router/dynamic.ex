defmodule Hydra.Router.Dynamic do
  @moduledoc """
  Generate routes from Hydra.Routes and handle HTTP requests for dynamic endpoints.
  """
  import Plug.Conn

  alias Hydra.{Router.Dynamic, RequestPipeline, Storage}

  defmacro dynamic_routes do
    if Application.get_env(:hydra, :running, false) do
      routes = :hydra
               |> Application.get_env(:storage)
               |> Keyword.get(:name)
               |> Storage.all
               |> Enum.map(&Dynamic.build/1)

      quote do
        unquote_splicing(routes)
      end
    end
  end

  @doc """
  Turn a Hydra.Route into a quoted Plug.Router.match/3
  """

  @spec build({atom, String.t, Route.t}) :: any
  def build({method, path, route}) do
    route = Macro.escape(route.requests)
    quote do
      match(unquote(path), via: unquote(method)) do
        Hydra.Router.Dynamic.call(var!(conn), unquote(route))
      end
    end
  end

  @doc """
  """
  @spec call(Plug.Conn.t, [%Hydra.Request{}]) :: Plug.Conn.t
  def call(conn, requests) do
    requests
    |> Enum.map(fn (req) -> RequestPipeline.async_start(req) end)
    |> aggregate_requests(%{})
    |> send_aggregate_resp(conn)
  end

  defp aggregate_requests([], result), do: result
  defp aggregate_requests([task|tasks], result) do
    case Task.yield(task, 500) do
      {:ok, reply} -> result = Map.merge(result, reply)
      nil -> tasks = [tasks|task]
    end
    aggregate_requests(tasks, result)
  end

  defp send_aggregate_resp(body, conn) do
    json = Poison.encode!(body)
    send_resp(conn, 200, json)
  end
end
