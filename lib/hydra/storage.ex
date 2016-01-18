defmodule Hydra.Storage do
  @moduledoc """
  Persistent storage of routes powered by DETS.
  """

  use GenServer

  alias Hydra.Route

  @default_storage Hydra.Storage.Memory

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  @doc false
  def init(opts) do
    data = Keyword.get(opts, :data, [])
    name = Keyword.get(opts, :name)
    storage = Keyword.get(opts, :storage, @default_storage)

    {:ok, tid} = storage.open(name)

    data |> Enum.each(&(storage.insert(tid, &1)))

    {:ok, {storage, tid}}
  end

  @doc """
  Handle cleanup on shutdown by closing our storage.
  """
  @spec terminate(any, tuple) :: none
  def terminate(_reason, {storage, name}), do: storage.close(name)

  @doc """
  All currently stored routes
  """
  @spec all(atom) :: [Route.t]
  def all(name), do: GenServer.call(name, :all)

  @doc """
  Insert a new route into the table
  """
  @spec insert(atom, Route.t) :: none
  def insert(name, %Route{method: method, path: path} = route) do
    GenServer.cast(name, {:insert, {method, path, route}})
  end

  @doc false
  def handle_call(:all, _from, {storage, name} = state) do
    result = storage.all(name)
    {:reply, result, state}
  end

  @doc false
  def handle_cast({:insert, record}, {storage, name} = state) do
    storage.insert(name, record)

    {:noreply, state}
  end
end
