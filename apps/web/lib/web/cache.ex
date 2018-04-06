defmodule Web.Cache do
  @moduledoc """
  """

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> actions()
    |> process()
  end

  defp actions(conn) do
    actions =
      conn
      |> get_req_headers("cache-control")
      |> Enum.reduce(headers, [], fn
        {_header, "no-cache"}, acc -> [:skip_cache | acc]
        {_header, "max-age=" <> seconds}, acc -> [String.to_integer(seconds) | acc]
        {_header, "no-store"}, acc -> [:no_caching | acc]
        _else, acc -> acc
      end)

    {conn, actions}
  end

  defp process({%{request_path: request_path} = conn, actions}, opts) do

    with default_ttl <- Keyword.get(opts, :ttl),
         ttl <- Enum.find(actions, &is_number/1),
         false <- skip?(actions),
         {:ok, body} <- Storage.Cache.get(:requests, request_path, (ttl or default_ttl))
    do
      send_resp(conn, 200, body)
    else
      _ -> put_private(conn, :hydra_cache, actions)
    end
  end

  defp skip?(actions) when :skip_cache in actions, do: true

  defp skip?(_), do: false
end
