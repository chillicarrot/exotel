defmodule Exotel.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exotel,
      version: "0.2.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:tesla, :proper_case],
      extra_applications: [:logger],
      mod: {Exotel.Application, []}
    ]
  end

  defp deps do
    [
      {:tesla, "~> 0.7.1"},
      {:proper_case, "~> 1.1"},
      {:poison, "~> 3.1"}
    ]
  end
end
