defmodule ZupplerUsers.Auth.Supervisor do
  @moduledoc """
  Provides oauth toke authorization with zuppler

  ## Dependencies

  poolboy, lrucache

  ## Setup

  In the app module add a new child supervisor(Zuppler.Auth, []])

  ## Usage
    user_info = Zuppler.Auth.auth(token)

    Authorization.ZupplerAuth.has_role(user_info, "restaurant")
    Authorization.ZupplerAuth.has_role(user_info, ["restaurant", "channel"])
    Authorization.ZupplerAuth.acls_for(user_info, :restaurant)
  """

  import Supervisor
  use Supervisor

  def start_link(state \\ []) do
    Supervisor.start_link(__MODULE__, state, [name: __MODULE__])
  end

  def pool_name, do: :zuppler_auth_pool

  def init(_state) do
    # pool_config = []
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, ZupplerUsers.Auth.Worker},
      {:size, 5},
      {:max_overflow, 10}
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, []),
      worker(LruCache, [:zuppler_auth_cache, 1000])
    ]

    supervise(children, strategy: :one_for_one)
  end

  @doc """
  Authetnicates a user by token. Returns user_info if success or nil if not
  """
  def auth(token) do
    with_cache(token, fn (token) ->
      :poolboy.transaction(pool_name(), fn(worker) ->
        :gen_server.call(worker, {:auth, token})
      end)
    end)
  end

  def with_cache(token, producer) do
    case LruCache.get(:zuppler_auth_cache, token) do
      nil ->
        data = producer.(token)
        LruCache.put(:zuppler_auth_cache, token, data)
        data
      data -> data
    end
  end

  @doc """
  Verifies if the user has a given role. Roles can be either a single string "admin" or an a list of string ["restaurant", "channel"].
  It returns true if the user has any of the given roles
  """
  def has_role(user_info, roles) do
    :poolboy.transaction(pool_name(), fn(worker) -> :gen_server.call(worker, {:has_any_role?, user_info, roles}) end)
  end

  @doc """
  Returns the given object ids on which the user has access to. subject must be a keyword

  Example

  Auth.acls_for(user_info, :restaurant)
  # => [2,3,4]

  """
  def acls_for(user_info, subject) do
    :poolboy.transaction(pool_name(), fn(worker) -> :gen_server.call(worker, {:acls_for, user_info, subject}) end)
  end
end
