defmodule Commercefacile.Web.UserController do
    use Commercefacile.Web, :controller

    plug Guardian.Plug.EnsureAuthenticated, [handler: Commercefacile.Web.ErrorController]
    when action in [:dashboard, :favorites, :settings]

    def dashboard(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        conn
        |> assign(:user, user)
        |> render("dashboard.html")
    end

    def favorites(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        conn
        |> assign(:user, user)
        |> render("favorites.html")
    end

    def settings(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        conn
        |> assign(:user, user)
        |> render("settings.html")
    end

    def shop(conn, _params) do
        conn
        |> render("shop.html")
    end
end