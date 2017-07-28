defmodule Commercefacile.Web.LayoutView do
  use Commercefacile.Web, :view

  def active_if_current(conn, [{:to, to}, {:controller, controller}, {:action, action}])
  when is_list(action)
  do
    active = 
      action
      |> Enum.map(fn(action) -> {controller, action} end)
    with true <- active_path?(conn, to: to, active: active) do
      "is-active"
    end
  end
  def active_if_current(conn, [{:to, to}, {:controller, controller}, {:action, action}]) do
    with true <- active_path?(conn, to: to, active: [{controller, action}]) do
      "is-active"
    end
  end
end
