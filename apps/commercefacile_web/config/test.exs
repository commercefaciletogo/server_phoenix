use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :commercefacile_web, Commercefacile.Web.Endpoint,
  http: [port: 4000],
  server: false
