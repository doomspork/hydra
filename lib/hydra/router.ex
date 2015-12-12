defmodule Hydra.Router do
  use Plug.Router
  use Plug.Debugger

  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass:  ["text/*"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Hi.")
  forward "/endpoints", to: Hydra.Routers.Endpoints
  match _, do: send_resp(conn, 404, "Oops!")
end
