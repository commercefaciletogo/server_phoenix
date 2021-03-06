defmodule Commercefacile.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Commercefacile.Web, :controller
      use Commercefacile.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: Commercefacile.Web
      import Plug.Conn
      import Commercefacile.Web.Router.Helpers
      import Commercefacile.Web.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/commercefacile_web/templates",
                        namespace: Commercefacile.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      use Phoenix.HTML.SimplifiedHelpers

      import Commercefacile.Web.Router.Helpers
      import Commercefacile.Web.ErrorHelpers
      import Commercefacile.Web.Gettext

      import PhoenixActiveLink
      import Commercefacile.Web.InputHelpers
      import Commercefacile.Web.FlashHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Commercefacile.Web.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
