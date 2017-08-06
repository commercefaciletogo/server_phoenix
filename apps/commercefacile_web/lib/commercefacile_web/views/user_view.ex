defmodule Commercefacile.Web.UserView do
    use Commercefacile.Web, :view

    def active_if_current(conn, [{:to, to}, {:controller, controller}, {:action, action}]) do
        with true <- active_path?(conn, to: to, active: [{controller, action}]) do
            "is-active"
        else
            false -> nil
        end
    end

    def ad_status_class(%{status: status}) when status == "online", do: " is-online"
    def ad_status_class(%{status: status}) when status == "offline", do: " is-offline"
    def ad_status_class(%{status: status}) when status == "pending", do: " is-pending"
    def ad_status_class(%{status: status}) when status == "rejected", do: " is-rejected"

    def ad_actions(%{status: status}) when status == "online", do: render("_online_ad_actions.html")
    def ad_actions(%{status: status}) when status == "offline", do: render("_offline_ad_actions.html")
    def ad_actions(%{status: status}) when status == "pending", do: render("_pending_ad_actions.html")
    def ad_actions(%{status: status}) when status == "rejected", do: render("_rejected_ad_actions.html")
end