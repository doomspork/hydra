defmodule Storage.Cache do
  @moduledoc """
  An ETS cache implementation
  """

  use GenServer

  require Logger

  @doc """
  Retrieves a cached result at `key` enforcing freshness with the configured ttl.
  """
  @spec get(atom(), binary()) :: {:ok, map()} : {:error, binary()}

  def get(table, key, ttl \\ nil) do
    with encoded_key <- encode(key),
         [{^encoded_key, record, timestamp}] <- lookup(table, encoded_key),
         ttl <- table_ttl(table),
         true <- fresh?(timestamp, ttl)
    do
      {:ok, record}
    else
      false ->
        remove(table, key)
        {:error, "expired"}
      [] ->
        {:error, "no hit"}
    end
  end

  @doc """
  """
  @spec init([atom(), ...]) :: {:ok, map()}

  def init(tables) do
    Enum.each(tables, &start_table/1)

    {:ok, %{}}
  end

  @doc """
  Proxy to `:ets.insert/3`.  Inserts the `value` in the `key` on `table`.
  """
  @spec put(atom(), binary(), any()) :: true

  def put(table, key, value) do
    :ets.insert(table, {encode(key), value, now()})
  end

  @doc """
  Proxy to `:ets.delete/2`, removes the record from the table if present.
  """
  @spec remove(atom(), binary()) :: true

  def remove(table, key), do: :ets.delete(table, encode(key))

  @doc """
  The `GenServer.start_link/1` for Storage.Cache
  """
  @spec start_link(keyword()) :: {:ok, pid()} | :ignore | {:error, {:already_started, pid()} | term()}

  def start_link(opts \\ []) do
    tables = Keyword.fetch!(opts, :tables)
    GenServer.start_link(__MODULE__, tables, name: __MODULE__)
  end

  defp encode(key), do: Base.encode64(key, padding: false)

  defp ets_select(fun, table) do
    :ets.select(table, fun)
  end

  defp fresh?(_timestamp, nil) do
    false
  end

  defp fresh?(timestamp, ttl) do
    (timestamp + ttl) > now()
  end

  defp lookup(table, key) do
    table
    |> lookup_fun(key)
    |> ets_select(table)
  end

  defp lookup_fun(encoded_key) do
    :ets.fun2ms(fn {^encoded_key, body, timestamp} -> {body, timestamp} end)
  end

  defp now, do: :os.system_time(:seconds)

  defp start_table(table),
    do: :ets.new(table, [:set, :named_table, read_concurrency: true, write_concurrency: true])
end
