use Mix.Config

config :commercefacile, ecto_repos: [Commercefacile.Repo]

import_config "#{Mix.env}.exs"
