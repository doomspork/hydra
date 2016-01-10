defmodule Hydra.Request do
  @moduledoc """
  HTTP Request struct and functionality
  """

  @derive [Poison.Encoder]
  defstruct [:url, :resp_filter]

  def get(url), do: HTTPoison.get(url)
  def get!(url) do
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      _ -> %{}
    end
  end

  def decode!(json), do: json |> Poison.decode!
end
