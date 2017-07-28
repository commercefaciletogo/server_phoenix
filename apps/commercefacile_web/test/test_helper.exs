ExUnit.configure formatters: [ExUnit.CLIFormatter, ExUnitNotifier, DocFirstFormatter]
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Commercefacile.Repo, :manual)

