defmodule Commercefacile.Application do
  @moduledoc """
  The Commercefacile Application Service.

  The commercefacile system business domain lives in this application.

  Exposes API to clients such as the `Commercefacile.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      worker(Commercefacile.Repo, []),
    ], strategy: :one_for_one, name: Commercefacile.Supervisor)
  end
end
