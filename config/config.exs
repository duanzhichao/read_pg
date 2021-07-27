# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :read_pg, ReadPgWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "02kWiRb2hX1WLfm4/EfLCQHOWe/w0w2QVCSXkOgXJSxtA7lOZvehTUHTmykFemqd",
  render_errors: [view: ReadPgWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ReadPg.PubSub,
  live_view: [signing_salt: "3NXcLedF"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
