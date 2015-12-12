defmodule Hydra.EndpointStorage do
  alias Hydra.Endpoint

  def start_link(_opts \\ []) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def lookup(path) do
    path = String.downcase(path)
    Agent.get(__MODULE__, fn (state) -> Map.get(state, path) end)
  end

  def register(%Endpoint{} = endpoint) do
    Agent.update(__MODULE__, fn (state) -> Map.put(state, endpoint.path, endpoint) end)
  end
end
