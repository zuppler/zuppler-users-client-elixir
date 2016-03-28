defmodule ZupplerUsers.Auth.Oauth do

  @moduledoc """
  This module defines the `get_user_token` method and provides functionality
  to get a valid token for accessing oauth protected endpoints.

  ## Notes

  * The user id is requred to generate token.

  ## Example:

  ```
  {:ok, token} =  ZupplerUsers.Auth.Oauth.get_user_token("12345")
  ```
  """

  @doc """
    Loads user token from Users based on user id and client_id, client_secret for this app
  """
  def get_user_token(user_id) do
    cfg = config
    body = "client_id=#{cfg[:client_id]}&client_secret=#{cfg[:client_secret]}&grant_type=client_credentials"
    json_resp = HTTPotion.post cfg[:token_url], [body: body]
    extract_token(json_resp, user_id)
  end

  defp config do
    cfg = Application.get_env(:zuppler_users_client, ZupplerUsers.Endpoint)
    if is_nil(cfg) || is_nil(cfg[:client_id]) ||
      is_nil(cfg[:client_secret]) || is_nil(cfg[:token_url]) || is_nil(cfg[:site]) do
      raise "Config <client_id, client_secret, token_url, site> are required. Please update config file"
    end
    cfg
  end

  defp extract_token(%{status_code: 200, body: body}, user_id) do
    body_resp = Poison.Parser.parse!(body, keys: :atoms)
    json_resp = HTTPotion.post "#{config[:site]}/v1/oauth", [
      body: "access_token=#{body_resp[:access_token]}&user_id=#{user_id}"
    ]
    get_response_token(json_resp)
  end

  defp extract_token(%{status_code: 401, body: _body}, _user_id), do: {:fail, "Could not load token"}

  defp get_response_token(%{status_code: 200, body: body}) do
    body_resp = Poison.Parser.parse!(body, keys: :atoms)
    {:ok, body_resp[:token]}
  end

  defp get_response_token(%{status_code: 401, body: _body}), do: {:fail, "Could not load token"}
end
