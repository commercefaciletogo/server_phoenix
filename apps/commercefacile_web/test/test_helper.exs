ExUnit.configure formatters: [ExUnitNotifier, DocFirstFormatter]
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Commercefacile.Repo, :manual)

