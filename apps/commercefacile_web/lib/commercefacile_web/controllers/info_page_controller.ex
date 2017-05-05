defmodule Commercefacile.Web.InfoPageController do
    use Commercefacile.Web, :controller

    def help(conn, _params) do
        render conn, "help.html"
    end

    def about(conn, _params) do
        render conn, "about.html"
    end

    def contact(conn, _params) do
        render conn, "contact.html"
    end

    def terms(conn, _params) do
        render conn, "terms.html"
    end

    def privacy(conn, _params) do
        render conn, "privacy.html"
    end
end