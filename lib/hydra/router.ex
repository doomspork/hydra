defmodule Hydra.Router do
  @moduledoc """
  Primary router for Hydra
  """
  use Plug.Router

  alias Hydra.Router.Dynamic
  import Dynamic

  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass:  ["text/*"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Hi.")
  forward "/admin", to: Hydra.Router.Admin

  dynamic_routes

  match _, do: send_resp(conn, 404, "Oops!")
end
