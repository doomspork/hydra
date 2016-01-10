defmodule Hydra.Transformer do
  @moduledoc """
  Transform JSON into desired format with JSON processor
  """

  alias Porcelain.Process, as: Proc

  def transform(json, filter) do
    json
    |> process(filter)
  end
  def transform!(json, filter) do
    case transform(json, filter) do
      {:ok, output} -> output
      {:error, error} -> raise error
    end
  end

  defp process(json, filter) do
    %Proc{pid: pid} = proc = Porcelain.spawn_shell("jq #{filter}", in: json, out: {:send, self()}, err: :out)
    receive do
      {^pid, :data, :out, output} ->
        Proc.stop(proc)
        {:ok, output}
    after
      5_000 -> {:error, "Failed to receive process response."}
    end
  end
end
