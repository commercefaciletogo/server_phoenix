ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Commercefacile.Repo, :manual)

formatters = [ExUnit.CLIFormatter]

if System.get_env("CI") do
  ExUnit.start formatters: formatters ++ [JUnitFormatter]
else
  ExUnit.start formatters: formatters
end

