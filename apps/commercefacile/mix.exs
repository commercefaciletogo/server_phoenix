defmodule Commercefacile.Mixfile do
  use Mix.Project

  def project do
    [app: :commercefacile,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Commercefacile.Application, []},
     extra_applications: [:logger, :runtime_tools]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:postgrex, ">= 0.0.0"},
    {:ksuid, "~> 0.1.2"},
    {:money, "~> 1.2"},
    {:timex, "~> 3.1"},
    {:openstex, "~> 0.3.6"},
    {:comeonin, "~> 3.2"},
    {:rummage_ecto, "~> 1.2"},
    {:py_cryptx, github: "thomasdola/py_cryptx", tag: "v0.0.1"},
    {:monetized, "~> 0.5.0"},
    {:hashids, "~> 2.0"},
    {:mapail, "~> 1.0"},
    {:openstex_adapters_rackspace, "~> 0.3.0"},
    {:junit_formatter, ">= 0.0.0", only: :test},
    {:mix_test_watch, "~> 0.3", only: :dev, runtime: false, override: true},
    {:doc_first_formatter, "~> 0.0.1", only: :test},
     {:ex_unit_notifier, "~> 0.1", only: :test},
     {:ecto, "~> 2.1"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
