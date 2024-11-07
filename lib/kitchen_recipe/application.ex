defmodule KitchenRecipe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KitchenRecipeWeb.Telemetry,
      KitchenRecipe.Repo,
      {DNSCluster, query: Application.get_env(:kitchen_recipe, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: KitchenRecipe.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: KitchenRecipe.Finch},
      # Start a worker by calling: KitchenRecipe.Worker.start_link(arg)
      # {KitchenRecipe.Worker, arg},
      # Start to serve requests, typically the last entry
      KitchenRecipeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KitchenRecipe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KitchenRecipeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
