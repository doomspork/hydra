defmodule Hydra.Server do
  @moduledoc """
  The Hydra server
  """

  def start_link(opts) do
    Plug.Adapters.Cowboy.http(Hydra.Router, [], opts)
  end
end
