defmodule Mercury.MixProject do
  use Mix.Project

  def project do
    [
      app: :mercury,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mercury.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
