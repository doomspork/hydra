defmodule Hydra.Storage.Memory do
  @moduledoc """
  Memory storage implementation.  ETS wrapper.
  """

  @spec open(atom) :: {:ok, atom}
  def open(name) do
    tid = :ets.new(name, [:set, :protected])
    {:ok, tid}
  end

  @spec all(atom) :: {:ok, [any]} | {:error, any}
  def all(name), do: name |> :ets.select([{:"$1", [], [:"$_"]}])

  @spec insert(atom, any) :: :ok | {:error, any}
  def insert(name, record), do: :ets.insert(name, record)

  @spec close(atom) :: :ok
  def close(_name), do: :ok
end
