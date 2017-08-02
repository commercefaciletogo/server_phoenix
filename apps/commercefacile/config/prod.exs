use Mix.Config

config :commercefacile, Commercefacile.Image,
    transformer: Commercefacile.Image.Transformer.ImageMagick,
    cloud_store: Commercefacile.Image.Storage.Opentex

config :commercefacile, Commercefacile.Services,
  generator: Commercefacile.Services.Generator,
  sms: [
    engine: Commercefacile.Services.SMS.Mock,
    originator: "C-Facile"
  ]

import_config "prod.secret.exs"
