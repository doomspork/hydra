# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config


config :hydra, :cowboy,
  port: 8080,
  ip: "0.0.0.0"
