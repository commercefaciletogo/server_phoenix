use Mix.Config

config :commercefacile, Commercefacile.Services,
  generator: Commercefacile.Services.Generator,
  sms: [
    engine: Commercefacile.Services.SMS.Mock,
    originator: "C-Facile"
  ]

import_config "prod.secret.exs"
