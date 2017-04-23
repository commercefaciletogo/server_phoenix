use Mix.Config

# Configure your database
config :commercefacile, Commercefacile.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "commercefacile_test",
  hostname: "172.17.0.3",
  pool: Ecto.Adapters.SQL.Sandbox
