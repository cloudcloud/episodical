defmodule Episodical.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EpisodicalWeb.Telemetry,
      Episodical.Repo,
      {DNSCluster, query: Application.get_env(:episodical, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Episodical.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Episodical.Finch},
      # Start a worker by calling: Episodical.Worker.start_link(arg)
      # {Episodical.Worker, arg},
      # Start to serve requests, typically the last entry
      EpisodicalWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Episodical.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EpisodicalWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def version, do: "0.0.1"
end
