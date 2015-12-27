defmodule Hydra.Endpoint do
  @moduledoc """
  Endpoint struct
  """

  @derive [Poison.Encoder]
  defstruct [:path, :description, :requests]
end
