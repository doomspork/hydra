defmodule Hydra do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hydra.EndpointStorage, []),
      supervisor(Task.Supervisor, [[name: Hydra.TaskSupervisor]])
    ]

    opts = [strategy: :one_for_one, name: Hydra.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
