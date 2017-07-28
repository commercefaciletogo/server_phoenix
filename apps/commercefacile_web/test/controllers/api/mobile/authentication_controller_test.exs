defmodule Ryme.Web.Api.Mobile.AuthenticationControllerTest do
    use Commercefacile.Web.ConnCase, async: true

    alias Commercefacile.Accounts

    @mock_token "token"

    describe "invalid" do
        @register_body %{username: "test_username", phone: "248089578", country_code: "00233", password: "ord", password_confirmation: "test_password"}
        @verify_body %{code: "123456", reference: @mock_token}
        @login_body %{phone: "248089578", country_code: "00233",  password: "test_password"}
        @phone_body %{, country_code: "00233", phone: "248089578", code: nil}
        @password_body %{password: "test_pssword", password_confirmation: "test_password"}

        test "returns error message for invalid input", %{conn: conn} do
            response = conn
                    |> post("/api/mobile/auth/register", @register_body)
                    |> json_response(400)

            assert %{"status" => "Bad Request", "code" => 400, "message" => %{}} = response
        end

        @tag :skip
        test "code verify user phone", %{conn: conn} do
            assert {:ok, %Accounts.User{}, %Accounts.Verification.Code{}} = Accounts.register(%{@register_body | password: "test_password"})
            response = conn
                    |> post("/api/mobile/auth/code", %{@verify_body | code: "521456"})
                    |> json_response(400)

            assert %{"status" => "Bad Request", "code" => 400, "message" => %{}} = response
            response = conn
                    |> post("/api/mobile/auth/code", %{@verify_body | code: "456"})
                    |> json_response(400)

            assert %{"status" => "Bad Request", "code" => 400, "message" => %{}} = response
        end

        @tag :skip
        test "ref verify user phone", %{conn: conn} do
            assert {:ok, %Accounts.User{}, %Accounts.Verification.Code{}} = Accounts.register(%{@register_body | password: "test_password"})
            response = conn
                    |> post("/api/mobile/auth/code", %{@verify_body | reference: "521456"})
                    |> json_response(422)

            assert %{"status" => "Unprocessable Entity", "code" => 422, "message" => "Unprocessable Entity"} = response
        end

        @tag :skip     
        test "credentials for login", %{conn: conn} do
        #     assert {:ok, %Accounts.User{}, %Accounts.Verification.Code{}} = Accounts.register(%{@register_body | password: "test_password"})
        #     Accounts.verify(:code, using: @verify_body)
            response = conn
                    |> post("/api/mobile/auth/login", @login_body)
                    |> json_response(400)

            assert %{"status" => _status, "code" => 400, "message" => "Incorrect Username / Password"} = response
        end
        @tag :skip
        test "user -> unverified (login)", %{conn: conn} do
            assert {:ok, %Accounts.User{}, %Accounts.Verification.Code{}} = Accounts.register(%{@register_body | password: "test_password"})
            response = conn
                    |> post("/api/mobile/auth/login", @login_body)
                    |> json_response(400)

            assert %{"status" => _status, "code" => 400, "message" => "User Not Verified"} = response
        end

        @tag :skip
        test "input for phone", %{conn: conn} do
            assert {:ok, %Accounts.User{}, %Accounts.Verification.Code{}} = Accounts.register(%{@register_body | password: "test_password"})
            assert {:ok, %Accounts.User{}} = Accounts.verify(:code, using: @verify_body)
            # submit your phone
            response = conn
                    |> post("/api/mobile/auth/phone", @phone_body)
                    |> json_response(400)

            assert %{"status" => "Bad Request", "code" => 400, "message" => %{}} = response
        end
        @tag :skip
        test "unkown phone", %{conn: conn} do
            assert {:ok, %Accounts.User{}, %Accounts.Verification.Code{}} = Accounts.register(%{@register_body | password: "test_password"})
            assert {:ok, %Accounts.User{}} = Accounts.verify(:code, using: @verify_body)
            # submit your phone
            response = conn
                    |> post("/api/mobile/auth/phone", %{@phone_body | phone: "0248089578", country_code: "00233"})
                    |> json_response(400)

            assert %{"status" => "Bad Request", "code" => 400, "message" => "Unkown Phone Number"} = response
        end
        @tag :skip
        test "user -> unverified (reset)", %{conn: conn} do
            assert {:ok, %Accounts.User{}, %Accounts.Verification.Code{}} = Accounts.register(%{@register_body | password: "test_password"})
            # submit your phone
            response = conn
                    |> post("/api/mobile/auth/phone", %{@phone_body | phone: "248089578", country_code: "00233"})
                    |> json_response(400)

            assert %{"status" => "Bad Request", "code" => 400, "message" => "User Not Verified"} = response
        end
        @tag :skip
        test "input for reset", %{conn: conn} do
            # register
            assert {:ok, %Accounts.User{}, %Accounts.Verification.Code{}} = Accounts.register(%{@register_body | password: "test_password"})
            # verify
            response = conn
                    |> post("/api/mobile/auth/code", @verify_body)
                    |> json_response(200)

            assert %{"status" => "ok", "code" => 200, "data" => data} = response
            # reset password
            response = conn
                    |> put_req_header("authorization", "Bearer #{Map.get(data, "jwt")}")
                    |> post("/api/mobile/auth/reset", @password_body)
                    |> json_response(400)

            assert %{"status" => "Bad Request", "code" => 400, "message" => %{}} = response
        end
    end

    describe "valid" do
        @register_body %{username: "test_username", 
                        phone: "248089578", 
                        country_code: "00233", 
                        password: "test_password", 
                        password_confirmation: "test_password"}
        @verify_body %{code: "123456", reference: @mock_token}
        @login_body %{username: "test_username", password: "test_password"}
        @phone_body %{phone: "248089578", code: "00233"}
        @password_body %{password: "test_password", password_confirmation: "test_password"}

        @tag :skip
        test "register user", %{conn: conn} do
            response = conn
                    |> post("/api/mobile/auth/register", @register_body)
                    |> json_response(200)

            expected = %{"status" => "ok", "code" => 200, "data" => %{"reference" => @mock_token}}
            assert response == expected
        end

        @tag :skip
        test "verify user phone", %{conn: conn} do
            Accounts.register(@register_body)
            response = conn
                    |> post("/api/mobile/auth/code", @verify_body)
                    |> json_response(200)

            assert %{"status" => _status, "code" => 200, "data" => %{"token" => _}} = response
        end

        @tag :skip
        test "login user", %{conn: conn} do
            Accounts.register(@register_body)
            Accounts.verify(:code, using: @verify_body)
            response = conn
                    |> post("/api/mobile/auth/login", @login_body)
                    |> json_response(200)

            assert %{"status" => _status, "code" => 200, "data" => %{"token" => _}} = response
        end

        @tag :skip
        test "reset password", %{conn: conn} do
            Accounts.register(@register_body)
            assert {:ok, %Accounts.User{}} = Accounts.verify(:code, using: @verify_body)
            # submit your phone
            response = conn
                    |> post("/api/mobile/auth/phone", @phone_body)
                    |> json_response(200)

            expected = %{"status" => "ok", "code" => 200, "data" => %{"reference" => @mock_token}}
            assert response == expected
            # verify your phone
            response = conn
                    |> post("/api/mobile/auth/code", @verify_body)
                    |> json_response(200)

            assert %{"status" => _status, "code" => 200, "data" => data} = response
            # change password
            response = conn
                    |> put_req_header("authorization", "Bearer #{Map.get(data, "token")}")
                    |> post("/api/mobile/auth/reset", @password_body)
                    |> json_response(200)

            expected = %{"status" => "ok", "code" => 200}
            assert response == expected
        end          
    end
end