defmodule CommercefacileAdmin.Web.PageController do
  use CommercefacileAdmin.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
