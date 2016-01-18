defmodule Hydra.Request do
  @moduledoc """
  HTTP Request struct and functionality
  """

  @derive [Poison.Encoder]
  defstruct [:url, :resp_filter]

  @type t :: %__MODULE__{url: String.t, resp_filter: String.t}

  @spec get(String.t) :: HTTPoison.Response.t
  def get(url), do: HTTPoison.get(url)
  def get!(url) do
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      _ -> %{}
    end
  end

  @spec decode!(String.t) :: map
  def decode!(json), do: json |> Poison.decode!
end
