use Mix.Config

# Configure your database
config :commercefacile, Commercefacile.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "commercefacile_dev",
  hostname: "localhost",
  pool_size: 10
