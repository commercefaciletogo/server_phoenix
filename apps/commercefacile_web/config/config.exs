# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :commercefacile_web,
  namespace: Commercefacile.Web,
  ecto_repos: [Commercefacile.Repo]

# Configures the endpoint
config :commercefacile_web, Commercefacile.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TRIjUT5Jdw9ZcpAjpsFIKT0Rr4KRlC8qj967MbmmSzA3ttI6XHboPwLmDyfWXWBP",
  render_errors: [view: Commercefacile.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Commercefacile.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :commercefacile_web, Commercefacile.Web.Gettext,
  default_locale: "fr"

config :guardian, Guardian,
  issuer: "Ryme",
  ttl: { 30, :days },
  allowed_drift: 2000,
  secret_key: "iiNzVREwn8giC857eqZ55iDaet5sK2CVtMB7EcUYuDfgSSP2iK4PlNj7UNlndo8W",
  serializer: Commercefacile.Web.Serializers.Guardian

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
