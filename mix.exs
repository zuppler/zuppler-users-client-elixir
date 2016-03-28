defmodule ZupplerUsers.Mixfile do
  use Mix.Project

  def project do
    [app: :zuppler_users_client,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "A module for authenticating Zuppler API using Zuppler Oauth",
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion]]
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
      {:phoenix, "~> 1.1.4"},
      {:oauth2, "~> 0.5"},
      {:httpotion, "~> 2.2.0"},
      {:poolboy, "~> 1.5"},
      {:lru_cache, "~> 0.1.0"},
      {:mix_test_watch, "~> 0.1.1", only: :dev},
      {:exvcr, "~> 0.7", only: :test},
      {:ex_doc, ">= 0.11.4", only: [:dev]}
   ]
  end

  defp package do
    [# These are the default files included in the package
     maintainers: ["Silviu Rosu", "Petrica Ghiurca"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/zuppler/zuppler-users-client-elixir.git",
              "Docs" => "https://github.com/zuppler/zuppler-users-client-elixir.git"}]
  end
end

