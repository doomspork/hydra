defmodule Hydra.Route do
  @moduledoc """
  Struct representing a Hydra route
  """

  @derive [Poison.Encoder]
  defstruct [:description, :method, :path, :requests]

  @type t :: %__MODULE__{description: String.t,
                         method: atom,
                         path: String.t,
                         requests: [Hydra.Request.t]}
end
