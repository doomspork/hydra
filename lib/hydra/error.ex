defmodule Hydra.Error do
  @moduledoc """
  Error struct and helper methods
  """

  @derive [Poison.Encoder]
  defstruct [:code, :message]

  @errors %{
    100 => "Bad request.  Malformed or missing data"
  }

  def get_error(code), do: %__MODULE__{code: code, message: message_lookup(code)}

  defp message_lookup(code), do: Map.get(@errors, code, "An error occurred.")
end
