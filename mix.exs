defmodule ZupplerUsers.Mixfile do
  use Mix.Project

  @version "0.0.5"

  def project do
    [app: :zuppler_users_client,
     name: "Zuppler Users Client",
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     docs: docs,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpotion]]
  end

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

  defp description do
    "An Elixir OAuth 2.0 Client Library to protect Zuppler API"
  end

  defp docs do
    [extras: ["README.md"],
     main: "readme",
     source_ref: "v#{@version}",
     source_url: "https://github.com/zuppler/zuppler-users-client-elixir"]
  end

  defp package do
    [files: ["lib", "priv", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Silviu Rosu", "Petrica Ghiurca"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/zuppler/zuppler-users-client-elixir.git"}]
  end
end
