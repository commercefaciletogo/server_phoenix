defmodule Commercefacile.Web.AuthControllerTest do
    use Commercefacile.Web.ConnCase

    setup %{conn: conn} do
        %{conn: Plug.Test.init_test_session(conn, %{})}
    end

    describe "register" do
        test "GET auth/enregistrer", %{conn: conn} do
            conn = get conn, "auth/enregistrer"
            assert html_response(conn, 200)
        end

        # @tag :skip
        test "POST", %{conn: conn} do
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post conn, "auth/enregistrer", payload
            assert %Commercefacile.Accounts.User{name: "pinana Pijo", phone: "002289110735"} = 
                Plug.Conn.get_session(conn, :user_in_register_mode)
            refute is_nil(Plug.Conn.get_session(conn, :code_reference))
            assert html_response(conn, 302)
        end
    end


    describe "code" do
        test "GET 404", %{conn: conn} do
            conn = get(conn, auth_path(conn, :get_code))
            assert html_response(conn, 404)
        end
        test "GET", %{conn: conn} do
            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:user_in_register_mode, %{name: "thomas"})
                |> Plug.Conn.put_session(:code_reference, "code")
                |> get(auth_path(conn, :get_code))
            assert html_response(conn, 200)
        end

        test "POST 302", %{conn: conn} do
            conn = post(conn, auth_path(conn, :post_code), %{code: %{code: "123456"}})
            assert html_response(conn, 302)
        end

        test "POST 400", %{conn: conn} do
            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:user_in_register_mode, %{name: "thomas"})
                |> Plug.Conn.put_session(:code_reference, "code")
                |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})
            assert html_response(conn, 400)
        end

        test "POST 302 success", %{conn: conn} do
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post(conn, auth_path(conn, :post_register), payload)

            conn = post(conn, auth_path(conn, :post_code), %{code: %{code: "123456"}})
            assert html_response(conn, 302)
        end
    end

    @login_payload %{login: %{phone: "+2289110735", password: "pass"}}
    describe "login" do
        test "GET", %{conn: conn} do
            conn = get(conn, auth_path(conn, :get_login))
            assert html_response(conn, 200)
        end

        test "POST no match", %{conn: conn} do
            conn = post(conn, auth_path(conn, :post_login), @login_payload)
            assert html_response(conn, 400)
            # assert "Wrong Phone / Password" = get_flash(conn, :error, "Wrong Phone / Password")
        end
        # @tag :skip
        test "POST not verified", %{conn: conn} do
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post(conn, auth_path(conn, :post_register), payload)
                |> post(auth_path(conn, :post_login), @login_payload)
            assert html_response(conn, 400)
            assert "+2289110735" = Plug.Conn.get_session(conn, :unverified_phone)
            # assert "Account is not yet verified, kindly verify it." = get_flash(conn, :error, "Wrong Phone / Password")
        end
        # @tag :skip
        test "POST ok", %{conn: conn} do
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post(conn, auth_path(conn, :post_register), payload)
                |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})
                |> post(auth_path(conn, :post_login), %{login: %{phone: "+2289110735", password: "secretpass"}})
            assert html_response(conn, 302)
        end
    end
    

    describe "verify" do
        test "GET 404", %{conn: conn} do
            conn = get(conn, auth_path(conn, :get_verify))
            assert html_response(conn, 404)
        end
        test "GET 200", %{conn: conn} do
            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:reset_mode, true)
                |> get(auth_path(conn, :get_verify))
            assert html_response(conn, 200)
        end

        # @tag :skip
        test "POST 400", %{conn: conn} do
            payload = %{verify: %{phone: "+2289110735"}}
            conn = post(conn, auth_path(conn, :post_verify), payload)
            # assert "Phone number is not found" = get_flash(conn, :error)
            assert html_response(conn, 400)
        end
        # @tag :skip
        test "POST ok", %{conn: conn} do
            # register
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post(conn, auth_path(conn, :post_register), payload)
                |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})
                |> get(auth_path(conn, :get_new_verify))
                |> post(auth_path(conn, :post_verify), %{verify: %{phone: "+2289110735"}})

            assert html_response(conn, 302)
            assert Plug.Conn.get_session(conn, :new_phone)
            assert %Commercefacile.Accounts.User{} = Plug.Conn.get_session(conn, :user_in_new_phone_mode)
        end
        test "POST 400 not found", %{conn: conn} do
            # register
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post(conn, auth_path(conn, :post_register), payload)
                |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})
                |> get(auth_path(conn, :get_new_verify))
                |> post(auth_path(conn, :post_verify), %{verify: %{phone: "+2289110435"}})

            assert html_response(conn, 400)
            assert Plug.Conn.get_session(conn, :new_phone)
            assert is_nil(Plug.Conn.get_session(conn, :user_in_new_phone_mode))
        end
    end

    describe "reset" do
        test "GET 404", %{conn: conn} do
            conn = get(conn, auth_path(conn, :get_reset))
            assert html_response(conn, 404)
        end
        test "GET ok", %{conn: conn} do
            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:reset_mode, true)
                |> Plug.Conn.put_session(:user_in_reset_mode, %{phone: "+2289110735"})
                |> get(auth_path(conn, :get_reset))
            assert html_response(conn, 200)
        end
    end

    test "logout", %{conn: conn} do
        payload = %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}
        assert {:ok, _, %{code: code, reference: reference}} = Commercefacile.Accounts.new_user(payload)
        code_changeset = %{code: code}
        assert {:ok, user} = Commercefacile.Accounts.verify_code(%{code_changeset: code_changeset, reference: reference})

        conn = Guardian.Plug.sign_in(conn, user)
       
        conn = delete(conn, auth_path(conn, :logout))
        assert html_response(conn, 302)
    end
end