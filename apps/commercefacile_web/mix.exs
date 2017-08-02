defmodule Commercefacile.Web.Mixfile do
  use Mix.Project

  def project do
    [app: :commercefacile_web,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Commercefacile.Web.Application, []},
     extra_applications: [:logger, :runtime_tools]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0-rc", override: true},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"}, 
     {:cowboy, "~> 1.0"},
     {:curtail, "~> 0.1.1"},
     {:remodel, "~> 0.0.4"},
     {:guardian, "~> 0.14.5"},
     {:navigation_history, "~> 0.2.2"},
     {:phoenix_active_link, "~> 0.0.1"},
     {:phoenix_html_simplified_helpers, "~> 1.2"},
     {:font_awesome_phoenix, "~> 1.0"},
     {:commercefacile, in_umbrella: true},
     {:commercefacile_admin, in_umbrella: true}, 
     {:junit_formatter, ">= 0.0.0", only: :test},
     {:doc_first_formatter, "~> 0.0.1", only: :test},
     {:mix_test_watch, "~> 0.3", only: :dev, runtime: false, override: true},
     {:ex_unit_notifier, "~> 0.1", only: :test}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
