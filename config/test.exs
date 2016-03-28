use Mix.Config

config :zuppler_users, ZupplerUsers.Endpoint,
  client_id: System.get_env("TEST_CLIENT_ID"),
  client_secret: System.get_env("TEST_CLIENT_SECRET"),
  redirect_uri: "http://localhost:4000/zuppler_users/callback",
  site: "http://users.biznettechnologies.com",
  authorize_url: "http://users.biznettechnologies.com/oauth/authorize",
  token_url: "http://users.biznettechnologies.com/oauth/token",
  current_user_url: "http://users.biznettechnologies.com/users/current.json",
  test_user_id: 14802

config :httpotion,
  default_timeout: 10000

config :exvcr, [
  vcr_cassette_library_dir: "test/vcr_cassettes",
  custom_cassette_library_dir: "test/custom_cassettes",
  filter_url_params: false,
  response_headers_blacklist: []
]
