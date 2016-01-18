use Mix.Config

config :hydra, :storage,
  name: :test_db,
  storage: Hydra.Storage.Memory
