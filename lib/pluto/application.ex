defmodule Pluto.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlutoWeb.Telemetry,
      Pluto.Repo,
      {DNSCluster, query: Application.get_env(:pluto, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pluto.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pluto.Finch},
      # Start a worker by calling: Pluto.Worker.start_link(arg)
      # {Pluto.Worker, arg},
      # Start to serve requests, typically the last entry
      PlutoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pluto.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlutoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
