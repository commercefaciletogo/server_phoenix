defmodule Commercefacile.Web.PageControllerTest do
  use Commercefacile.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Bienvenu sur Commercefacile.com"
  end

  test "GET /ads", %{conn: conn} do
    conn = get conn, "/ads"
    assert html_response(conn, 200) =~ "Ads page /en"
  end  
end
