use Mix.Config

# Configure your database
config :commercefacile, Commercefacile.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "commercefacile_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :commercefacile, Commercefacile.Image,
    transformer: Commercefacile.Image.Transformer.Mock,
    store: Commercefacile.Image.Storage.Mock


config :commercefacile, Commercefacile.Services,
  generator: Commercefacile.Services.Generator.Mock,
  sms: [
    engine: Commercefacile.Services.SMS.Mock,
    originator: "C-Facile"
  ]