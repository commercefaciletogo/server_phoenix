use Mix.Config

# Configure your database
config :commercefacile, Commercefacile.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "commercefacile_dev",
  password: "commercefacile_dev",
  database: "commercefacile_dev",
  hostname: "172.17.0.2",
  pool_size: 10
