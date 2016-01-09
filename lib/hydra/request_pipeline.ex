defmodule Hydra.RequestPipeline do
  @moduledoc """
  Pipeline for requesting, transforming, and caching data.
  """

  alias Hydra.Request

  def async_start(request) do
    Task.Supervisor.async(Hydra.TaskSupervisor, __MODULE__, :start, [request])
  end

  def start(%Request{url: url, resp_filter: filter}) do
    case cached_request(url) do
      nil ->
        url
        |> get!
        |> decode!
        |> transform!(filter)
      cached -> cached
    end
  end

  defp cached_request(url), do: nil

  defp get!(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      _ -> %{}
    end
  end

  defp decode!(body), do: body |> Poison.decode!

  defp transform!(body, filter), do: body

end
