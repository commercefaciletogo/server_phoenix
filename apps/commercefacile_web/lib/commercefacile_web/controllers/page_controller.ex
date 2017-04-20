defmodule Commercefacile.Web.PageController do
  use Commercefacile.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
