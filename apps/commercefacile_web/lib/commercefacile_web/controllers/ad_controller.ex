defmodule Commercefacile.Web.AdController do
    use Commercefacile.Web, :controller

    plug Guardian.Plug.EnsureAuthenticated, [handler: Commercefacile.Web.ErrorController]
    when action in [:private_save, :edit, :update, :delete]

    @ad_conditions [[key: "New", value: "New"], [key: "Used", value: "Used"]]
    @ad_images_session_key :ad_images

    def index(conn, _params) do
        # get categories
        categories = Commercefacile.Ads.get_categories(:main_with_children)
            |> Commercefacile.Web.Serializers.AdController.Index.Categories.to_map
        # get locations
        locations = Commercefacile.Locations.get_regions(:togo, :with_cities)
            |> Commercefacile.Web.Serializers.AdController.Index.Locations.to_map
        render conn, "index.html", categories: categories, locations: locations
    end

    def create(conn, _params) do
        changeset = Commercefacile.Ads.Ad.changeset(:new)
        # get categories
        categories = Commercefacile.Ads.get_categories(:main_with_children)
            |> Commercefacile.Web.Serializers.AdController.Create.Categories.to_list(:select)
             # get locations
        locations = Commercefacile.Locations.get_regions(:togo, :with_cities)
            |> Commercefacile.Web.Serializers.AdController.Create.Locations.to_list(:select)
        conn
        |> get_ad_images
        |> render("create.html", categories: categories, locations: locations, changeset: changeset, conditions: @ad_conditions)
    end

    def save(conn, %{"ad" => %{"phone" => phone} = ad}) do
        # make sure of no invalid data
        images = get_session(conn, @ad_images_session_key) || []
        ad = Map.merge(ad, %{"images" => images})
        changeset = Commercefacile.Ads.Ad.changeset(ad, :guest)
        if changeset.valid? do
            conn = put_session(conn, :guest, Commercefacile.Accounts.new_guest(ad))
            # check phone is taken
            case Commercefacile.Accounts.phone_taken?(phone) do
                false -> 
                    {:ok, user, %{reference:  reference}} = Commercefacile.Accounts.new_user(ad)
                    put_session(conn, :user_in_register_mode, user)
                    |> put_session(:code_reference, reference)
                    |> redirect(to: auth_path(conn, :get_code))
                {true, :unverified_user} -> 
                    put_flash(conn, :info, "Verify your phone to countinue")
                    |> redirect(to: auth_path(conn, :get_verify))
                {true, :inactive_user} -> 
                    put_status(conn, 400)
                    |> put_flash(:info, "Phone belongs to inactive account, contact adminst.. or new account")
                    |> assign(:changeset, changeset)
                    |> render("create.html")
                {true, :active_user} -> 
                    redirect(conn, to: auth_path(conn, :get_login))
            end
        else
            put_status(conn, 400)
            |> assign(:changeset, changeset)
            |> add_fixtures(:select)
            |> render("create.html")
        end
    end

    def private_save(conn, %{"ad" => ad} = params) do
        user = Guardian.Plug.current_resource(conn)
        # IO.inspect params
        images = get_session(conn, @ad_images_session_key) || []
        ad = Map.merge(ad, %{"images" => images})
        # IO.inspect ad
        case Commercefacile.Ads.new_ad(ad, user) do
            {:ok, _} -> 
                conn
                |> redirect(to: user_path(conn, :dashboard, user.phone))
            {:error, :invalid_date, changeset} ->
                conn
                |> put_status(400)
                |> assign(:changeset, %{changeset | action: :validate})
                |> add_fixtures(:select)
                |> render("create.html")
            {:error, :internal_error} ->
                conn
                |> put_status(500)
                |> put_view(Commercefacile.Web.ErrorView)
                |> render("500.html")
            {:error, changeset} ->
                conn
                |> put_status(400)
                |> assign(:changeset, changeset)
                |> add_fixtures(:select)
                |> render("create.html")
        end
    end

    defp get_ad_images(conn) do
        case get_session(conn, @ad_images_session_key) do
            nil -> 
                IO.inspect("Session Images is empty")
                assign(conn, :images, [])
            old when is_list(old) ->
                conn = assign(conn, :images, old)
                IO.inspect(get_session(conn, @ad_images_session_key))
                conn
        end
    end

    def show(conn, _params) do
        # ad = get_ad
        render conn, "show.html"
    end

    def edit(conn, %{uuid: uuid}) do
        case Commercefacile.Ads.get_ad(uuid: uuid) do
            {:error, :not_found} -> 
                redirect(conn, to: "/")
            {:ok, ad} -> 
                assign(conn, :changeset, ad)
                |> add_fixtures(:select)
                |> render("edit.html")
        end
    end

    def update(conn, %{uuid: uuid, ad: ad}) do
        user = Guardian.Plug.current_resource(conn)
        case Commercefacile.Ads.update_ad(uuid: uuid, ad: ad) do
            {:error, changeset} -> 
                assign(conn, :changeset, changeset)
                |> put_status(400)
                |> add_fixtures(:select)
                |> render("edit.html")
            {:ok, _} -> 
                redirect(conn, to: user_path(conn, :dashboard, user.phone))
        end
    end

    def delete(conn, %{uuid: uuid}) do
        user = Guardian.Plug.current_resource(conn)
        case Commercefacile.Ads.delete_ad(uuid: uuid) do
            {:error, :not_found} -> 
                redirect(conn, to: "/")
            {:ok, _} -> 
                redirect(conn, to: user_path(conn, :dashboard, user.phone))
        end
    end

    defp add_fixtures(conn, :select) do
        categories = Commercefacile.Ads.get_categories(:main_with_children)
            |> Commercefacile.Web.Serializers.AdController.Create.Categories.to_list(:select)
            # get locations
        locations = Commercefacile.Locations.get_regions(:togo, :with_cities)
            |> Commercefacile.Web.Serializers.AdController.Create.Locations.to_list(:select)

        assign(conn, :locations, locations)
        |> assign(:categories, categories)
        |> assign(:conditions, @ad_conditions)
    end
end