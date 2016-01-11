defmodule Hydra do
  @moduledoc """
  Hydra OTP application
  """

  use Application

  def main(args), do: Mix.Task.run "hydra", args

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hydra.EndpointStorage, []),
      worker(Hydra.Server, [server_opts]),
      supervisor(Task.Supervisor, [[name: Hydra.TaskSupervisor]])
    ]

    opts = [strategy: :one_for_one, name: Hydra.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def server_opts, do: Application.get_env(:hydra, :server)
end
