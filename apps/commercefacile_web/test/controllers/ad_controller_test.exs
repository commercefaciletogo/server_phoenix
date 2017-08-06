defmodule Commercefacile.Web.AdControllerTest do
    use Commercefacile.Web.ConnCase

    @form_data %{ad: %{
            title: "title of ad", condition: "new", description: "jflad,f akdfjal,f adkfjald,f akdfjald", 
            price: "200", negotiable: true, category_id: 15,
            name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass",
            location_id: 7, terms: true
        }}
    @ad_images [
            "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg",
            "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"
        ]
    @register_payload payload = %{register: %{terms: true, name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass"}}

    setup %{conn: conn} do
        %{conn: Plug.Test.init_test_session(conn, %{})}
    end

    test "GET /annonces", %{conn: conn} do
        {conn, user} = simulate_sign_in(conn)
        ad = %{title: "title of ad", condition: "new", 
            description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", 
            negotiable: true, category_id: 15, 
            images: [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg"]
            }
        assert {:ok, %{uuid: uuid}} = Commercefacile.Ads.new_ad(ad, user)
        Commercefacile.Ads.review_ad(uuid)

        conn = get(conn, ad_path(conn, :index))
        assert html_response(conn, 200)
    end

    # @tag :skip
    test "GET /annonces/uuid 302", %{conn: conn} do
        conn = get(conn, ad_path(conn, :index))
        conn = get(conn, ad_path(conn, :show, "jfakdjklfajsdklfjkl"))
        assert html_response(conn, 404)
    end

    # @tag :skip
    test "GET ad 200", %{conn: conn} do
        {conn, user} = simulate_sign_in(conn)
        ad = %{title: "title of ad", condition: "new", 
            description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", 
            negotiable: true, category_id: 15, 
            images: [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg",
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"]
            }
        assert {:ok, %{uuid: uuid}} = Commercefacile.Ads.new_ad(ad, user)
        Commercefacile.Ads.review_ad(uuid)

        conn = get(conn, ad_path(conn, :show, uuid))
        assert html_response(conn, 200)
    end

    # @tag :skip
    test "GET /annonces/uuid/edit 401", %{conn: conn} do
        conn = get(conn, ad_path(conn, :edit, "jfakdjklfajsdklfjkl"))
        assert redirected_to(conn, 401) =~ auth_path(conn, :get_login)
    end

    # @tag :skip
    test "GET /annonces/uuid/edit 404", %{conn: conn} do
        {conn, _} = simulate_sign_in(conn)
        conn = get(conn, ad_path(conn, :edit, "jfakdjklfajsdklfjkl"))
        assert html_response(conn, 404)
    end

    # @tag :skip
    test "GET /annonces/uuid/edit 200", %{conn: conn} do
        {conn, user} = simulate_sign_in(conn)
        ad = %{title: "title of ad", condition: "new", 
            description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", 
            negotiable: true, category_id: 15, 
            images: [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg",
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"]
            }
        assert {:ok, %{uuid: uuid}} = Commercefacile.Ads.new_ad(ad, user)
        # Commercefacile.Ads.review_ad(uuid)

        conn = get(conn, ad_path(conn, :edit, uuid))
        assert html_response(conn, 200)
    end

    # @tag :skip
    test "PUT pending ad", %{conn: conn} do
        {conn, user} = simulate_sign_in(conn)
        ad = %{title: "title of ad", condition: "new", 
            description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", 
            negotiable: true, category_id: 15, 
            images: [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg",
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"]
            }
        assert {:ok, %{uuid: uuid}} = Commercefacile.Ads.new_ad(ad, user)

        update_data = %{ad | title: "new title of ad"}
        conn = Plug.Conn.fetch_session(conn)
            |> Plug.Conn.put_session(:ad_images, update_data.images)
            |> put(ad_path(conn, :update, uuid), %{ad: update_data})

        assert redirected_to(conn, 302) =~ user_path(conn, :dashboard, user.phone)
    end

    # @tag :skip
    test "PUT rejected ad", %{conn: conn} do
        {conn, user} = simulate_sign_in(conn)
        ad = %{title: "title of ad", condition: "new", 
            description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", 
            negotiable: true, category_id: 15, 
            images: [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg"]
            }
        assert {:ok, %{uuid: uuid}} = Commercefacile.Ads.new_ad(ad, user)
        rejected_fields = %{fields: "title, price"}
        assert {:ok, _} = Commercefacile.Ads.review_ad(uuid, rejected_fields)

        update_data = %{ad | title: "new title of ad", price: "300"}
        conn = Plug.Conn.fetch_session(conn)
            |> Plug.Conn.put_session(:ad_images, update_data.images)
            |> put(ad_path(conn, :update, uuid), %{ad: update_data})

        assert redirected_to(conn, 302) =~ user_path(conn, :dashboard, user.phone)
    end

    # @tag :skip
    test "DELETE ad", %{conn: conn} do
        {conn, user} = simulate_sign_in(conn)
        ad = %{title: "title of ad", condition: "new", 
            description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", 
            negotiable: true, category_id: 15, 
            images: [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg"]
            }
        assert {:ok, %{uuid: uuid}} = Commercefacile.Ads.new_ad(ad, user)
        conn = delete(conn, ad_path(conn, :delete, uuid))
        assert redirected_to(conn, 302) =~ user_path(conn, :dashboard, user.phone)
    end

    # @tag :skip
    test "GET /annonces/créer", %{conn: conn} do
        conn = get(conn, ad_path(conn, :create))
        assert html_response(conn, 200)
    end

    describe "POST save" do
        # @tag :skip
        test "POST ad 302 virgin", %{conn: conn} do
            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:ad_images, @ad_images)
                |> post(ad_path(conn, :save), @form_data)

            assert redirected_to(conn, 302) =~ auth_path(conn, :get_code)
        end

        # @tag :skip
        test "POST ad 302 unverfied number", %{conn: conn} do
            post(conn, auth_path(conn, :post_register), @register_payload)

            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:ad_images, @ad_images)
                |> post(ad_path(conn, :save), @form_data)

            assert "+2289110735" = Plug.Conn.get_session(conn, :unverified_phone)
            assert redirected_to(conn, 302) =~ auth_path(conn, :get_verify)
        end

        # @tag :skip
        test "POST ad 302 active user", %{conn: conn} do
            post(conn, auth_path(conn, :post_register), @register_payload)
            |> post(auth_path(conn, :post_code), %{code: %{code: "123456"}})

            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:ad_images, @ad_images)
                |> post(ad_path(conn, :save), @form_data)

            assert "+2289110735" = Plug.Conn.get_session(conn, :login_phone)
            assert redirected_to(conn, 302) =~ auth_path(conn, :get_login)
        end
    end
    
    describe "POST private_save" do
        # @tag :skip
        test "401 to login", %{conn: conn} do
            conn = post(conn, ad_path(conn, :private_save), %{ad: %{}})
            assert redirected_to(conn, 401) =~ auth_path(conn, :get_login)
        end

        # @tag :skip
        test "302 to dashboard", %{conn: conn} do
            {conn, _} = simulate_sign_in(conn)

            conn = Plug.Conn.fetch_session(conn)
                |> Plug.Conn.put_session(:ad_images, @ad_images)
                |> post(ad_path(conn, :private_save), @form_data)

            assert redirected_to(conn, 302) =~ user_path(conn, :dashboard, "002289110735")
        end
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