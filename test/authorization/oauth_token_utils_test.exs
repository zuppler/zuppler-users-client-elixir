defmodule ZupplerUsers.Auth.OauthTest do
  use ExUnit.Case
  use ExVCR.Mock
  import ZupplerUsers.Auth.Oauth

  doctest ZupplerUsers.Auth.Oauth

  setup_all do
    cfg = Application.get_env(:zuppler_users_client, ZupplerUsers.Endpoint)
    {:ok, test_user_id: cfg[:test_user_id]}
  end

  test "get user token", %{test_user_id: test_user_id} do
    use_cassette "oauth_get_user_token" do
      case get_user_token(test_user_id) do
      {:ok, token} ->
        assert token != nil
      {:fail, message} ->
        raise message
     end
    end
  end
end
