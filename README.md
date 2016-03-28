# Zuppler Users Client

Zuppler Users Elixir client for autorizing zuppler API. It consists of a token generator and a plug to add to Phoenix

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add zuppler_users_client to your list of dependencies in `mix.exs`:

        def deps do
          [{:zuppler_users_client, "~> 0.0.1"}]
        end

  2. Ensure zuppler_users_client is started before your application:

        def application do
          [applications: [:zuppler_users_client]]
        end
