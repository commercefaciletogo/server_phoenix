defmodule Commercefacile.Web.UserControllerTest do
    use Commercefacile.Web.ConnCase

    setup %{conn: conn} do
        %{conn: Plug.Test.init_test_session(conn, %{})}
    end

    test "GET /", %{conn: conn} do
        {conn, %{phone: phone}} = simulate_sign_in(conn)
        conn = get(conn, user_path(conn, :dashboard, phone))
        assert html_response(conn, 200)
    end

    test "GET favoris", %{conn: conn} do
        {conn, %{phone: phone}} = simulate_sign_in(conn)
        conn = get(conn, user_path(conn, :favorites, phone))
        assert html_response(conn, 200)
    end

    test "GET paramètres", %{conn: conn} do
        {conn, %{phone: phone}} = simulate_sign_in(conn)
        conn = get(conn, user_path(conn, :settings, phone))
        assert html_response(conn, 200)
    end

    test "GET boutique", %{conn: conn} do
        {conn, %{phone: phone}} = simulate_sign_in(conn)
        conn = get(conn, user_path(conn, :shop, phone))
        assert html_response(conn, 200)
    end

    defp simulate_sign_in(conn) do
        payload = %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}
        assert {:ok, _, %{code: code, reference: reference}} = Commercefacile.Accounts.new_user(payload)
        code_changeset = %{code: code}
        assert {:ok, user} = Commercefacile.Accounts.verify_code(%{code_changeset: code_changeset, reference: reference})

        conn = Guardian.Plug.sign_in(conn, user)
        {conn, user}
    end
end