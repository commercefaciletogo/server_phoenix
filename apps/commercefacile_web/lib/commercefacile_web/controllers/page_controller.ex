defmodule Commercefacile.Web.PageController do
  use Commercefacile.Web, :controller

  def index(conn, _params) do
    map = Commercefacile.Locations.get_map(:togo)
    regions = Commercefacile.Locations.get_regions(:togo)
    cities = Commercefacile.Locations.get_cities(6, :togo)
    categories = Commercefacile.Ads.get_categories(:main)

    render conn, "index.html", map: map, regions: regions, cities: cities, categories: categories
  end

  def ads(conn, _params) do
    render conn, "ads.html"
  end
end
