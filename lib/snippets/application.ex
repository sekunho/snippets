defmodule Snippets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Snippets.Repo,
      # Start the Telemetry supervisor
      SnippetsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Snippets.PubSub},
      # Start the Endpoint (http/https)
      SnippetsWeb.Endpoint
      # Start a worker by calling: Snippets.Worker.start_link(arg)
      # {Snippets.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Snippets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SnippetsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
