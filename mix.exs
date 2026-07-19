defmodule Korangar.MixProject do
  use Mix.Project

  def project do
    [
      app: :korangar,
      version: "0.1.0",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def cli do
    [
      preferred_envs: [test: :test, docs: :docs]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4.4"},
      {:ecto, "~> 3.13.5", optional: true},
      {:rustler, "~> 0.37.2", github: "rusterlium/rustler", sparse: "rustler_mix", runtime: false}
    ]
  end
end
