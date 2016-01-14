defmodule Hydra.Mixfile do
  use Mix.Project

  def project do
    [app: :hydra,
     description: """
     A multi-headed beast: API gateway, request cache, and data transformations
     """,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     escript: escript,
     package: package]
  end

  def application do
    [applications: [:cowboy, :logger, :plug, :httpoison, :porcelain],
     mod: {Hydra, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:httpoison, "~> 0.8.0"},
     {:poison, "~> 1.5"},
     {:porcelain, "~> 2.0"},
     {:dogma, "~> 0.0.11", only: [:dev, :test]}]
  end

  defp escript do
    [main_module: Hydra]
  end

  def package do
    [maintainers: ["Sean Callan"],
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     licenses: ["Apache 2.0"],
     links: %{github: "https://github.com/doomspork/hydra"}]
  end
end
