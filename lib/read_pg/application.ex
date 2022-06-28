defmodule ReadPg.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    ReadPg.ets_new()
    children = [
      # Start the Ecto repository
      # Start the Telemetry supervisor
      ReadPgWeb.Telemetry,
      ReadPg.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ReadPg.PubSub},
      # Start the Endpoint (http/https)
      ReadPgWeb.Endpoint
      # Start a worker by calling: ReadPg.Worker.start_link(arg)
      # {ReadPg.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReadPg.Supervisor]
    supervisor = Supervisor.start_link(children, opts)
    ReadPg.set_time()
    supervisor
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ReadPgWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
