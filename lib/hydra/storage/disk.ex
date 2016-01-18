defmodule Hydra.Storage.Disk do
  @moduledoc """
  Disk storage implementation.  DETS wrapper.
  """

  @spec open(atom) :: {:ok, atom} | {:error, String.t}
  def open(name), do: :dets.open_file(name, [type: :set])

  @spec all(atom) :: {:ok, [any]} | {:error, String.t}
  def all(name), do: name |> :dets.select({:"$1", [], [:"$_"]})

  @spec insert(atom, any) :: :ok | {:error, String.t}
  def insert(name, record), do: :dets.insert(name, record)

  @spec close(atom) :: :ok | {:error, String.t}
  def close(name), do: :dets.close(name)
end
