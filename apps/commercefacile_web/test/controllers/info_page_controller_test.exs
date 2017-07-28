defmodule Commercefacile.Web.InfoPageControllerTest do
    use Commercefacile.Web.ConnCase

    test "GET /help" do
        first_response = build_conn()
                    |> get(info_page_path(build_conn(), :help))
                    |> html_response(200)

        second_response = build_conn()
                    |> get("/help")
                    |> html_response(200)

        assert first_response =~ "help page"
        assert second_response =~ "help page"
    end

    test "GET /about" do
        first_response = build_conn()
                    |> get(info_page_path(build_conn(), :about))
                    |> html_response(200)

        second_response = build_conn()
                    |> get("/about")
                    |> html_response(200)

        assert first_response =~ "about page"
        assert second_response =~ "about page"
    end

    test "GET /contact" do
        first_response = build_conn()
                    |> get(info_page_path(build_conn(), :contact))
                    |> html_response(200)

        second_response = build_conn()
                    |> get("/contact")
                    |> html_response(200)

        assert first_response =~ "contact page"
        assert second_response =~ "contact page"
    end

    test "GET /privacy" do
        first_response = build_conn()
                    |> get(info_page_path(build_conn(), :privacy))
                    |> html_response(200)

        second_response = build_conn()
                    |> get("/privacy")
                    |> html_response(200)

        assert first_response =~ "privacy page"
        assert second_response =~ "privacy page"
    end

    test "GET /terms" do
        first_response = build_conn()
                    |> get(info_page_path(build_conn(), :terms))
                    |> html_response(200)

        second_response = build_conn()
                    |> get("/terms")
                    |> html_response(200)

        assert first_response =~ "terms page"
        assert second_response =~ "terms page"
    end
end