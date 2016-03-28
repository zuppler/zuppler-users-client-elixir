defmodule ZupplerUsers.Auth.Plug do
  import Plug.Conn
  alias ZupplerUsers.Auth.Util
  alias ZupplerUsers.Auth.Supervisor

  @behaviour Plug

  @moduledoc """
  Plug that protects routes from unauthenticated access.

  ## Notes

  This plug will be injected in phoenix pipeline to protect api endpoints.

  Token is retrieved:

    - either from header: *authorization* and value *"Bearer \#{token}"*
    - either from body params: *auth_token*

  After authorization the decoded user_info is assigned to the connection
  under the key *user_info*.
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
