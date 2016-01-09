defmodule Hydra.EndpointStorage do
  @moduledoc """
  Storage for our dynamic endpoints
  """

  alias Hydra.Endpoint

  def start_link(_opts \\ []) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def lookup(path) do
    path = String.downcase(path)
    Agent.get(__MODULE__, fn (state) -> Map.get(state, path) end)
  end

  def register(%Endpoint{path: path} = endpoint) do
    Agent.update(__MODULE__, fn (state) -> Map.put(state, path, endpoint) end)
  end
end
