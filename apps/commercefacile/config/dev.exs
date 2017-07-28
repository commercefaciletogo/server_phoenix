use Mix.Config

# Configure your database
config :commercefacile, Commercefacile.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "commercefacile_dev",
  hostname: "localhost",
  pool_size: 10


config :commercefacile, Commercefacile.Services,
  generator: Commercefacile.Services.Generator,
  sms: [
    engine: Commercefacile.Services.SMS.Mock,
    originator: "C-Facile"
  ]