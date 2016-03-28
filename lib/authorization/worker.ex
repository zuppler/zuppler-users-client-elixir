defmodule ZupplerUsers.Auth.Worker do
  use GenServer
  alias ZupplerUsers.Auth.User

  @moduledoc """
  Process worker that will proxy messages to module functions
  """

  def start_link(state) do
    :gen_server.start_link(__MODULE__, state, [])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:auth, token}, from, state) do
    {:reply, User.auth(token), state}
  end

  def handle_call({:has_any_role?, user_info, roles}, from, state) do
    {:reply, User.has_any_role?(user_info, roles), state}
  end

  def handle_call({:acls_for, user_info, subject}, from, state) do
    {:reply, User.acls_for(user_info, subject), state}
  end
end
