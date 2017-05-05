defmodule Commercefacile.Web.PageController do
  use Commercefacile.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def ads(conn, _params) do
    render conn, "ads.html"
  end
end
