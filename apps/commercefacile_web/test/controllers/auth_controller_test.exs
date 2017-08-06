defmodule Commercefacile.Web.AuthControllerTest do
    use Commercefacile.Web.ConnCase

    @guest_data %{
            "title" => "title of ad", "condition" => "new", "description" => "jflad,f akdfjal,f adkfjald,f akdfjald", 
            "price" => "200", "negotiable" => true, "category_id" => 15,
            "name" => "pinana Pijo", "phone" => "+22890110735", "password" => "secretpass", "password_confirmation" => "secretpass",
            "location" => "0rYff8dQmyO6SIC01iLSs2oRzA5", "terms" => true, "images" => [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg",
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"
            ]
        }

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
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+22890110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post conn, "auth/enregistrer", payload
            refute is_nil(Plug.Conn.get_session(conn, :user_in_register_mode))
            refute is_nil(Plug.Conn.get_session(conn, :code_reference))
            assert redirected_to(conn, 302) == auth_path(conn, :get_code)
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
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+22890110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post(conn, auth_path(conn, :post_register), payload)

            conn = post(conn, auth_path(conn, :post_code), %{code: %{code: "123456"}})
            assert html_response(conn, 302)
        end

        test "POST with guest data", %{conn: conn} do
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+22890110735", password: "secretpass", password_confirmation: "secretpass"}}
            guest = Commercefacile.Accounts.new_guest(@guest_data)
            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:guest, guest)

            conn = post(conn, auth_path(conn, :post_register), payload)
            conn = post(conn, auth_path(conn, :post_code), %{code: %{code: "123456"}})
            assert redirected_to(conn, 302) =~ user_path(conn, :dashboard, "0022890110735")
            assert is_nil(Plug.Conn.get_session(conn, :guest))
        end
    end

    @login_payload %{login: %{phone: "+22890110735", password: "pass"}}
    @register_payload payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+22890110735", password: "secretpass", password_confirmation: "secretpass"}}
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
            conn = post(conn, auth_path(conn, :post_register), @register_payload)
                |> post(auth_path(conn, :post_login), @login_payload)
            assert html_response(conn, 400)
            assert "+22890110735" = Plug.Conn.get_session(conn, :unverified_phone)
            # assert "Account is not yet verified, kindly verify it." = get_flash(conn, :error, "Wrong Phone / Password")
        end
        # @tag :skip
        test "POST ok", %{conn: conn} do
            conn = post(conn, auth_path(conn, :post_register), @register_payload)
                |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})
                |> post(auth_path(conn, :post_login), %{login: %{phone: "+22890110735", password: "secretpass"}})
            assert html_response(conn, 302)
        end

        test "POST ok with guest data", %{conn: conn} do
            post(conn, auth_path(conn, :post_register), @register_payload)
            |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})

            guest = Commercefacile.Accounts.new_guest(@guest_data)
            conn = Plug.Conn.fetch_session(conn)        
                |> Plug.Conn.put_session(:guest, guest)
                |> post(auth_path(conn, :post_login), %{login: %{phone: "+22890110735", password: "secretpass"}})
            
            # assert html_response(conn, 302)
            assert redirected_to(conn, 302) =~ user_path(conn, :dashboard, "0022890110735")
            assert is_nil(Plug.Conn.get_session(conn, :guest))
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
            payload = %{verify: %{phone: "+22890110735"}}
            conn = post(conn, auth_path(conn, :post_verify), payload)
            assert html_response(conn, 400)
        end
        # @tag :skip
        test "POST ok", %{conn: conn} do
            # register
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+22890110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post(conn, auth_path(conn, :post_register), payload)
                |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})
                |> get(auth_path(conn, :get_new_verify))
                |> post(auth_path(conn, :post_verify), %{verify: %{phone: "+22890110735"}})

            assert html_response(conn, 302)
            assert Plug.Conn.get_session(conn, :new_phone)
            refute is_nil(Plug.Conn.get_session(conn, :user_in_new_phone_mode))
        end
        test "POST 400 not found", %{conn: conn} do
            # register
            payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+22890110735", password: "secretpass", password_confirmation: "secretpass"}}
            conn = post(conn, auth_path(conn, :post_register), payload)
                |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})
                |> get(auth_path(conn, :get_new_verify))
                |> post(auth_path(conn, :post_verify), %{verify: %{phone: "+22890110435"}})

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
                |> Plug.Conn.put_session(:user_in_reset_mode, %{phone: "+22890110735"})
                |> get(auth_path(conn, :get_reset))
            assert html_response(conn, 200)
        end
    end

    test "logout", %{conn: conn} do
        payload = %{terms: true, name: "pinana Pijo", phone: "+22890110735", password: "secretpass", password_confirmation: "secretpass"}
        assert {:ok, _, %{code: code, reference: reference}} = Commercefacile.Accounts.new_user(payload)
        code_changeset = %{code: code}
        assert {:ok, user} = Commercefacile.Accounts.verify_code(%{code_changeset: code_changeset, reference: reference})

        conn = Guardian.Plug.sign_in(conn, user)
       
        conn = post(conn, auth_path(conn, :logout))
        assert html_response(conn, 302)
    end
end