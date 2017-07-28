defmodule Commercefacile.Web.AdControllerTest do
    use Commercefacile.Web.ConnCase

    test "GET /annonces" do
        first_response = build_conn()
                    |> get(ad_path(build_conn(), :index))
                    |> html_response(200)

        second_response = build_conn()
                    |> get("/annonces")
                    |> html_response(200)

        assert first_response =~ "<!DOCTYPE html>"
        assert second_response =~ "<!DOCTYPE html>"
    end

    test "GET /annonces/uuid" do
        first_response = build_conn()
                    |> get(ad_path(build_conn(), :show, "jfakdjklfajsdklfjkl"))
                    |> html_response(200)

        second_response = build_conn()
                    |> get("/annonces/fjaldjfakdjflkasdjkf")
                    |> html_response(200)

        assert first_response =~ "<!DOCTYPE html>"
        assert second_response =~ "<!DOCTYPE html>"
    end

    test "GET /annonces/créer" do
        first_response = build_conn()
                    |> get(ad_path(build_conn(), :create))
                    |> html_response(200)

        second_response = build_conn()
                    |> get("/annonces/créer")
                    |> html_response(200)

        assert first_response =~ "<!DOCTYPE html>"
        assert second_response =~ "<!DOCTYPE html>"
    end
end