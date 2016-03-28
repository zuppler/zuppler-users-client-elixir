defmodule ZupplerUsers.Auth.Plug do
  import Plug.Conn
  alias ZupplerUsers.Auth.Util
  alias ZupplerUsers.Auth.Supervisor

  @behaviour Plug

  @moduledoc """
  Plug that protects routes from unauthenticated access.
  If a header with name "authorization" and value "Bearer \#{token}"
  is present, and "token" can be decoded with the applications token secret
  or the auth_token param is in the body,
  the user is authenticated and the decoded token is assigned to the connection
  under the key "user_info".
  """
  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case Util.token_from_conn(conn) do
      {:ok, token } ->
        case Supervisor.auth(token) do
          {:ok, user_info} ->
            assign(conn, :user_info, user_info)
          {:fail, message} -> Util.send_error(conn, message, 401)
        end
      {:error, _message} ->
        Util.send_error(conn, "Not Authorized", 401)
    end
  end
end
