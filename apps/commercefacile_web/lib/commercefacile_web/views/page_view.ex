defmodule Commercefacile.Web.PageView do
  use Commercefacile.Web, :view

  def ad_path_from_home(conn, id, :location) do
    ad_path(conn, :index) <> "?l=" <> id
  end
  def ad_path_from_home(conn, id, :category) do
    ad_path(conn, :index) <> "?c=" <> id
  end
end
