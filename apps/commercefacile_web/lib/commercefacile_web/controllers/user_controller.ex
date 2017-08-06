defmodule Commercefacile.Web.UserController do
    use Commercefacile.Web, :controller

    plug Guardian.Plug.EnsureAuthenticated, [handler: Commercefacile.Web.ErrorController]
    when action in [:dashboard, :favorites, :settings]

    plug :redirect_if_not_owner when action in [:dashboard, :favorites, :settings]
    plug :redirect_if_not_active

    alias Commercefacile.Web.Serializers.UserController, as: Serializer
    alias Commercefacile.Accounts.Embededs

    def dashboard(conn, %{"phone" => phone} = params) do
        user = Guardian.Plug.current_resource(conn)
        %{result: ads, pagination: paginate} = Commercefacile.Ads.list(Map.merge(params, %{"owner" => phone}))
        conn
            |> assign(:owner, user)
            |> assign(:ads, Serializer.Dashboard.Ad.to_map(ads))
            |> assign(:paginate, paginate)
            |> render("dashboard.html")
    end

    def favorites(conn, _) do
        user = Guardian.Plug.current_resource(conn)
        %{ads: ads} = Commercefacile.Ads.favorites(user.id)
        conn
            |> assign(:owner, user)
            |> assign(:ads, Serializer.Shop.Ad.to_map(ads))
            |> render("favorites.html")
    end

    def settings(conn, _) do
        user = Guardian.Plug.current_resource(conn)
        locations = Commercefacile.Locations.get_regions(:togo, :with_cities)
            |> Serializer.Settings.Locations.to_list(:select)
        conn
            |> assign(:owner, user)
            |> assign(:locations, locations)
            |> assign(:info_changeset, Embededs.changeset(%{name: user.name, phone: user.phone, email: user.email, location_id: user.location_id}, :info))
            |> assign(:password_changeset, Embededs.changeset(:password))
            |> render("settings.html")
    end

    def shop(conn, %{"phone" => phone} = params) do
        case Commercefacile.Ads.shop(params, phone: phone) do
            {:error, _} ->
                put_status(conn, :not_found)
                |> put_view(Commercefacile.Web.ErrorView)
                |> render("404.html")
            %{result: ads, pagination: paginate, owner: owner} ->
                ads = Serializer.Shop.Ad.to_map(ads)
                assign(conn, :ads, ads)
                |> assign(:paginate, paginate)
                |> assign(:owner, owner)
                |> render("shop.html")
        end
    end

    def redirect_if_not_owner(%Plug.Conn{params: %{"phone" => phone}} = conn, _) do
        user = Guardian.Plug.current_resource(conn)
        unless user.phone == phone do
            redirect(conn, to: user_path(conn, :shop, phone))
            |> halt()
        else
            conn
        end
    end

    def redirect_if_not_active(%Plug.Conn{params: %{"phone" => phone}} = conn, _) do
        unless Commercefacile.Accounts.phone_active?(phone) do
            put_view(conn, Commercefacile.Web.ErrorView)
            |> render("404.html")
            |> halt()
        else
            conn
        end
    end
end