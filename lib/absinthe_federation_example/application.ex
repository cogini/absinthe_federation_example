defmodule AbsintheFederationExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @app :absinthe_federation_example

  @impl true
  def start(_type, _args) do
    OpentelemetryEcto.setup([@app, :repo])
    :opentelemetry_cowboy.setup()
    # OpentelemetryPhoenix.setup(adapter: :cowboy2)
    OpentelemetryLiveView.setup()

    roles = Application.get_env(@app, :roles, [:api])
    Logger.info("Starting with roles: #{inspect(roles)}")

    children =
      List.flatten([
        AbsintheFederationExampleWeb.Telemetry,
        AbsintheFederationExample.Repo,
        {DNSCluster, query: Application.get_env(:absinthe_federation_example, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: AbsintheFederationExample.PubSub},
        # Start the Finch HTTP client for sending emails
        {Finch, name: AbsintheFederationExample.Finch},
        AbsintheFederationExampleWeb.Endpoint,
        cluster_supervisor()
      ])

    opts = [strategy: :one_for_one, name: AbsintheFederationExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cluster_supervisor do
    topologies = Application.get_env(:libcluster, :topologies, [])

    if Enum.empty?(topologies) do
      []
    else
      [{Cluster.Supervisor, [topologies, [name: AbsintheFederationExample.ClusterSupervisor]]}]
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AbsintheFederationExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
