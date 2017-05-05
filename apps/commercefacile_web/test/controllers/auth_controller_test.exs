# defmodule Commercefacile.Web.AuthControllerTest do
#     use Commercefacile.Web.ConnCase

#     test "GET /register", %{conn: conn} do
#         conn = get conn, "/register"
#         assert html_response(conn, 200) =~ "register page"
#     end

#     test "GET /phone", %{conn: conn} do
#         conn = get conn, "/ads"
#         assert html_response(conn, 200) =~ "phone verification page"
#     end

#     test "GET /login", %{conn: conn} do
#         conn = get conn, "/login"
#         assert html_response(conn, 200) =~ "login page"
#     end

#     test "GET /logout", %{conn: conn} do
#         conn = get conn, "/logout"
#         assert html_response(conn, 200) =~ "Bienvenu sur Commercefacile.com"
#     end

#     test "GET /reset", %{conn: conn} do
#         conn = get conn, "/reset"
#         assert html_response(conn, 200) =~ "reset page"
#     end
# end