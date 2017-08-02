defmodule Commercefacile.Web.ErrorController do
    use Commercefacile.Web, :controller

    def unauthenticated(conn, _params) do
        conn
        |> put_status(401)
        |> save_intended_path
        |> redirect(to: auth_path(conn, :get_login))
    end

    defp save_intended_path(conn) do
        path = conn.request_path
        put_session(conn, :intended, path)
    end
end