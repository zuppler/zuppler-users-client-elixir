defmodule ZupplerUsers.Auth.Util do
  import Phoenix.Controller, only: [json: 2]
  import Plug.Conn

  @moduledoc """
  This module defines the utility functions to extract token from request
  and to send unauthenticated error on response if token is not present
  """

  def send_error(conn, error_msg, status \\ 422) do
    conn
    |> put_status(status)
    |> json(%{success: false, status: %{code: status, message: error_msg}})
    |> halt
  end

  # def presence_validator(field, nil), do: [{field, "can't be blank"}]
  # def presence_validator(field, ""), do: [{field, "can't be blank"}]
  # def presence_validator(_field, _), do: []

  def token_from_conn(conn) do
    header_token = Plug.Conn.get_req_header(conn, "authorization") |> token_from_header
    case header_token do
      {:ok, token} -> {:ok, token}
      {:error, :not_present} ->
        case get_token_from_params(conn) do
          {:ok, token} -> {:ok, token}
          {:error, :not_present} ->
            {:error, "Token not present"}
        end
    end
  end

  defp get_token_from_params(conn) do
    conn = fetch_query_params(conn)
    if Dict.has_key?(conn.params, "access_token") do
      {:ok, conn.params["access_token"] || conn.params[:access_token]}
    else
      {:error, :not_present}
    end
  end

  defp token_from_header(["Bearer " <> token]), do: {:ok, token}
  defp token_from_header(_), do: {:error, :not_present}
end
