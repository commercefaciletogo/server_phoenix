defmodule Commercefacile.Web.InfoPageControllerTest do
    use Commercefacile.Web.ConnCase

    test "GET /help", %{conn: conn} do
        conn = get conn, "/help"
        assert html_response(conn, 200) =~ "help page"
    end

    test "GET /about", %{conn: conn} do
        conn = get conn, "/about"
        assert html_response(conn, 200) =~ "about page"
    end

    test "GET /contact", %{conn: conn} do
        conn = get conn, "/contact"
        assert html_response(conn, 200) =~ "contact page"
    end

    test "GET /privacy", %{conn: conn} do
        conn = get conn, "/privacy"
        assert html_response(conn, 200) =~ "privacy page"
    end

    test "GET /terms", %{conn: conn} do
        conn = get conn, "/terms"
        assert html_response(conn, 200) =~ "terms page"
    end
end