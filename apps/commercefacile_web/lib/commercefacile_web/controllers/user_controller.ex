defmodule Commercefacile.Web.UserController do
    use Commercefacile.Web, :controller

    def dashboard(conn, _params) do
        conn
        |> render("dashboard.html")
    end

    def favorites(conn, _params) do
        conn
        |> render("favorites.html")
    end

    def settings(conn, _params) do
        conn
        |> render("settings.html")
    end

    def shop(conn, _params) do
        conn
        |> render("shop.html")
    end
end