defmodule PipelineTest do
  use ExUnit.Case
  doctest Pipeline

  test "greets the world" do
    assert Pipeline.hello() == :world
  end
end
