defmodule Hydra.Endpoint do
  @derive [Poison.Encoder]
  defstruct [:path, :description, :requests]
end
