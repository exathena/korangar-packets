defmodule KorangarPackets.MixProject do
  use Mix.Project

  def project do
    [
      app: :korangar_packets,
      version: "0.1.0",
      elixir: "~> 1.20",
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
      {:jason, "~> 1.4.5", optional: true},
      {:ecto, "~> 3.14.1", optional: true},
      {:rustler, "~> 0.38.0", runtime: false}
    ]
  end
end
