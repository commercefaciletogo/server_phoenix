defmodule Commercefacile.Web.UserView do
    use Commercefacile.Web, :view

    def active_if_current(conn, [{:to, to}, {:controller, controller}, {:action, action}]) do
        with true <- active_path?(conn, to: to, active: [{controller, action}]) do
            "is-active"
        else
            false -> nil
        end
    end
end