defmodule ZupplerUsers.Auth.UserTest do
  use ExUnit.Case
  use ExVCR.Mock

  alias ZupplerUsers.Auth.User

  test "authentication with broken token" do
    use_cassette "no_token" do
      assert {:fail, _} = User.auth("1234")
    end
  end

  test "authentication with valid token" do
    use_cassette "user_test_valid_token" do
      assert {:ok, _} = User.auth(get_user_token)
    end
  end

  test "acls" do
    use_cassette "user_test_valid_token_acl" do
      assert {:ok, user_info} = User.auth(get_user_token)
      assert [623, 145] == User.acls_for(user_info, :restaurant)
      assert nil == User.acls_for(user_info, :channel)
    end
  end

  test "has_role" do
    use_cassette "user_test_valid_token_roles" do
      {:ok, user_info} = User.auth(get_user_token)
      user_info
      |> User.has_any_role?("config")
      |> assert

      user_info
      |> User.has_any_role?(["bla", "config"])
      |> assert
    end
  end

  test "has_role negative" do
    use_cassette "user_test_valid_token" do
      {:ok, user_info} = User.auth(get_user_token)

      user_info
      |> User.has_any_role?("no-role")
      |> Kernel.not
      |> assert

      user_info
      |> User.has_any_role?(["bla", "no-role"])
      |> Kernel.not
      |> assert
    end
  end

  def get_user_token do
    cfg = Application.get_env(:zuppler_users, ZupplerUsers.Endpoint)
    test_user_id = cfg[:test_user_id]
    {:ok, token} = ZupplerUsers.Auth.Oauth.get_user_token(test_user_id)
    token
  end
end
