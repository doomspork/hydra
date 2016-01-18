# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :dogma,
  rule_set: Dogma.RuleSet.All,

  override: %{
    LineLength    => [ max_length: 120 ],
    FunctionArity => [ max: 5 ],
  }

config :hydra, :server,
  port: 8080,
  ip: {0, 0, 0, 0}

import_config "#{Mix.env}.exs"
