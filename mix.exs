defmodule Stockfighter.Mixfile do
  use Mix.Project

  def project do
    [app: :stockfighter,
     version: "0.0.1",
     elixir: "~> 1.1",
     name: "Stockfigher",
     escript: escript_config,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :jsx, :tzdata]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8"},
      {:jsx, "~> 2.8"},
      {:timex, "~> 0.19.2"},
      {:tzdata, "~> 0.1.8", override: true},
      {:socket, "~> 0.3.1", git: "https://github.com/meh/elixir-socket.git"},
    ]
  end

  def escript_config do
    [main_module: Stockfighter.CLI]
  end
end
