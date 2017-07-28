defmodule Commercefacile.Web.UserControllerTest do
    use Commercefacile.Web.ConnCase

    test "GET /0022890698954", %{conn: conn} do
        response = 
            conn
            |> get("/0022890698954")
            |> html_response(200)

        assert response =~ "<!DOCTYPE html>"
    end

    test "GET /0022890698954/favoris", %{conn: conn} do
        response = 
            conn
            |> get("/0022890698954/favoris")
            |> html_response(200)

        assert response =~ "<!DOCTYPE html>"
    end

    test "GET /0022890698954/paramètres", %{conn: conn} do
        response = 
            conn
            |> get("/0022890698954/paramètres")
            |> html_response(200)

        assert response =~ "<!DOCTYPE html>"
    end

    test "GET /0022890698954/boutique", %{conn: conn} do
        response = 
            conn
            |> get("/0022890698954/boutique")
            |> html_response(200)

        assert response =~ "<!DOCTYPE html>"
    end
end