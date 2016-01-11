defmodule Hydra.CLI do
  @moduledoc """
  Command line interface for Hydra
  """

  def parse_args(args) do
    {opts, _, _} = OptionParser.parse(args, aliases: [p: :port], switches: [port: :integer])
    opts
    |> ip_tuple
  end

  defp ip_tuple(opts) do
    case opts[:ip] do
      nil -> opts
      ip ->
        ip
        |> String.split(".")
        |> Enum.map(&(String.to_integer(&1)))
        |> List.to_tuple
    end
  end
end
