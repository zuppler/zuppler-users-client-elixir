defmodule ZupplerUsers.Auth.User do

  def has_any_role?(user_info, user_roles) when is_list(user_roles) do
    r1 = MapSet.new user_roles
    r2 = MapSet.new user_info.roles
    Enum.count(MapSet.intersection(r1, r2)) > 0
  end

  def has_any_role?(user_info, user_role) do
    has_any_role? user_info, List.wrap(user_role)
  end

  def acls_for(user_info, kind), do: user_info.acls[kind]

  @doc """
    Loads user info from Zuppler Users based on user token.
    Response is in this format:
    {:ok, %{info:
                %{acls: %{}, email: "test@zuppler.com", id: 14802,
                  name: "Test Account", phone: "1234567890",
                  roles: ["restaurant"]
            }, provider: "zuppler", uid: "10768"}
    }
    If token is not valid response will be
    {:fail, "Not authorized"}
  """
  def auth(token) do
    case HTTPotion.get user_url, query: [access_token: token] do
      %{status_code: 200, body: body} ->
        {:ok, Poison.Parser.parse!(body, keys: :atoms).info}
      %{status_code: 401, body: _body} ->
        {:fail, "Not authorized"}
    end
  end

  def user_url do
    config = Application.get_env(:zuppler_users, ZupplerUsers.Endpoint)
    config[:current_user_url]
  end
end
