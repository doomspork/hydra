defmodule Hydra.TransformerTest do
  use ExUnit.Case, async: true

  alias Hydra.Transformer

  @json """
  [{
    "name": "Sean"
  },
  {
    "name": "Jeff"
  }]
  """

  @filter "'.[0]'"

  @expected_output """
  {
    "name": "Sean"
  }
  """

  test "transforms JSON" do
    assert Transformer.transform(@json, @filter) == {:ok, @expected_output}
  end
end
