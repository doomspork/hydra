defmodule Hydra do
  @moduledoc """
  Hydra OTP application
  """

  use Application

  def main(args), do: Mix.Task.run "hydra", args

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hydra.Storage, [storage_opts]),
      worker(Hydra.Server, [server_opts]),
      supervisor(Task.Supervisor, [[name: Hydra.TaskSupervisor]])
    ]

    opts = [strategy: :one_for_one, name: Hydra.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Recompile and load Hydra.Router
  """
  def reload do
    Code.load_file("lib/hydra/router.ex")
  end

  defp server_opts, do: Application.get_env(:hydra, :server)
  defp storage_opts, do: Application.get_env(:hydra, :storage)
end
