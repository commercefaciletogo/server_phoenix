defmodule CommercefacileAdmin.PageController do
  use CommercefacileAdmin, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
