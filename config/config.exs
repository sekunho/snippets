# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :snippets,
  ecto_repos: [Snippets.Repo]

# Configures the endpoint
config :snippets, SnippetsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vj7AlD9e//lkblDEtl03bVW7VV4zsCCQ+xQPurrNWd9lM2Kxw0QHdDgHShOM4+hz",
  render_errors: [view: SnippetsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Snippets.PubSub,
  live_view: [signing_salt: "ECN7yegr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
