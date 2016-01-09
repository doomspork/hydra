defmodule Hydra.Request do
  @moduledoc """
  Request struct
  """

  @derive [Poison.Encoder]
  defstruct [:url, :resp_filter]
end
