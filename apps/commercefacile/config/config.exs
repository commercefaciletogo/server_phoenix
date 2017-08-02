use Mix.Config

config :commercefacile, ecto_repos: [Commercefacile.Repo]

# config :rummage_ecto, Rummage.Ecto, default_repo: Commercefacile.Repo

config :commercefacile, Commercefacile.Image.Storage.Opentex.Cloudfiles,
  adapter: Openstex.Adapters.Rackspace.Cloudfiles.Adapter,
  rackspace: [
    api_key: "3dd9d8333f3c49afa05ed8999f06fe70",
    username: "commercefacile",
    password: "~uw%[FPW8v<Qd4Tf"
  ],
  keystone: [
    tenant_id: :nil,
    user_id: :nil,
    endpoint: "https://identity.api.rackspacecloud.com/v2.0"
  ],
  swift: [
    account_temp_url_key1: System.get_env("RACKSPACE_CLOUDFILES_TEMP_URL_KEY1"), # defaults to :nil if absent
    account_temp_url_key2: System.get_env("RACKSPACE_CLOUDFILES_TEMP_URL_KEY2"), # defaults to :nil if absent
    region: :nil
  ],
  hackney: [
    timeout: 20000,
    recv_timeout: 180000
  ]

config :commercefacile, Commercefacile.Image.Storage.Opentex.CloudfilesCDN,
  adapter: Openstex.Adapters.Rackspace.CloudfilesCDN.Adapter,
  rackspace: [
    api_key: "3dd9d8333f3c49afa05ed8999f06fe70",
    username: "commercefacile",
    password: "~uw%[FPW8v<Qd4Tf"
  ],
  keystone: [
    tenant_id: :nil,
    user_id: :nil,
    endpoint: "https://identity.api.rackspacecloud.com/v2.0"
  ],
  swift: [
    account_temp_url_key1: System.get_env("RACKSPACE_CLOUDFILESCDN_TEMP_URL_KEY1"), # defaults to :nil if absent
    account_temp_url_key2: System.get_env("RACKSPACE_CLOUDFILESCDN_TEMP_URL_KEY2"), # defaults to :nil if absent
    region: :nil
  ],
  hackney: [
    timeout: 20000,
    recv_timeout: 180000
  ]

config :httpipe,
  adapter: HTTPipe.Adapters.Hackney

import_config "#{Mix.env}.exs"
