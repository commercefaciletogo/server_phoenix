defmodule Commercefacile.Web.UploadControllerTest do
    use Commercefacile.Web.ConnCase

    test "uploads image and deletes", %{conn: conn} do
        upload = %Plug.Upload{path: Path.expand("test/fixtures/test.jpg"), filename: "test.jpg"}
        response = conn
            |> post("/uploads", %{image: upload})
            |> json_response(200)
        
        assert %{"status" => "ok", "code" => 200, "data" => %{"filename" => filename}} = response

        response = conn
            |> delete("/uploads/#{filename}")
            |> json_response(200)
        
        assert %{"status" => "ok", "code" => 200} = response
    end
end