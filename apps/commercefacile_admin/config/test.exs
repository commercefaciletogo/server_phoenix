use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :commercefacile_admin, CommercefacileAdmin.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :commercefacile_admin, CommercefacileAdmin.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "commercefacile_admin_test",
  hostname: "172.17.0.4",
  pool: Ecto.Adapters.SQL.Sandbox
