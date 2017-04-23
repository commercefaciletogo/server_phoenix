# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :commercefacile_admin,
  namespace: CommercefacileAdmin,
  ecto_repos: [CommercefacileAdmin.Repo]

# Configures the endpoint
config :commercefacile_admin, CommercefacileAdmin.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DUw4GgWJTWQzhW7b6GZxIuAZHm+mecf+Rv65zrbLr8q78KRiuWYLClgYBUtueWLq",
  render_errors: [view: CommercefacileAdmin.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CommercefacileAdmin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
