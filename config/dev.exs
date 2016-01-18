use Mix.Config

config :hydra, :storage,
  name: :dev_db,
  storage: Hydra.Storage.Memory
