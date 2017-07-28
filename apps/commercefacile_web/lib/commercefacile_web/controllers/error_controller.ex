defmodule Commercefacile.Web.ErrorController do
    use Commercefacile.Web, :controller

    def unauthenticated(conn, _params) do
        conn
        |> put_status(401)
        |> redirect(to: auth_path(conn, :get_login))
    end
end