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
      {:phoenix, "~> 1.2.0"},
      {:oauth2, "~> 0.6"},
      {:httpotion, "~> 3.0.0"},
      {:poolboy, "~> 1.5.1"},
      {:lru_cache, "~> 0.1.0"},
      {:mix_test_watch, "~> 0.2.6", only: :dev},
      {:exvcr, "~> 0.8.1", only: :test},
      {:ex_doc, ">= 0.13.0", only: [:dev]}
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
