defmodule Hydra.RequestPipeline do
  @moduledoc """
  Pipeline for requesting, transforming, and caching data.
  """

  import Hydra.Request, only: [decode!: 1, get!: 1]
  import Hydra.Transformer, only: [transform!: 2]

  alias Hydra.Request

  def async_start(request) do
    Task.Supervisor.async(Hydra.TaskSupervisor, __MODULE__, :start, [request])
  end

  def start(%Request{url: url, resp_filter: filter}) do
    case cached_request(url) do
      nil ->
        url
        |> get!
        |> transform!(filter)
        |> decode!
      cached -> cached
    end
  end

  defp cached_request(_url), do: nil
end
