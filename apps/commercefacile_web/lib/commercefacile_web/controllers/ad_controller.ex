defmodule Commercefacile.Web.AdController do
    use Commercefacile.Web, :controller

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
        changeset = Commercefacile.Ads.Ad.changeset(ad, :new_for_guest)
        if changeset.valid? do
            conn = put_session(conn, :guest, Commercefacile.Accounts.new_guest(ad))
            # check phone is taken
            if Commercefacile.Accounts.user_phone_taken?(phone) do
                # if true then redirect to login page
                redirect(conn, to: auth_path(conn, :get_login))
            else
                # if false redirect to code page
                {:ok, user, %{reference:  reference}} = Commercefacile.Accounts.new_user(ad)
                conn = put_session(conn, :user_in_register_mode, user)
                conn = put_session(conn, :code_reference, reference)
                redirect(conn, to: auth_path(conn, :get_code))
            end
        else
            categories = Commercefacile.Ads.get_categories(:main_with_children)
                |> Commercefacile.Web.Serializers.AdController.Create.Categories.to_list(:select)
                # get locations
            locations = Commercefacile.Locations.get_regions(:togo, :with_cities)
                |> Commercefacile.Web.Serializers.AdController.Create.Locations.to_list(:select)
            conn
            |> get_ad_images
            |> assign(:changeset, %{changeset | action: :validate})
            |> render("create.html", categories: categories, locations: locations, conditions: @ad_conditions)
        end
    end
    def save(conn, %{"ad" => ad} = params) do
        IO.inspect params
        images = get_session(conn, @ad_images_session_key) || []
        ad = Map.merge(ad, %{"images" => images})
        IO.inspect ad
        changeset = Commercefacile.Ads.Ad.changeset(ad, :new_for_user)
        if changeset.valid? do
            conn = delete_session(conn, @ad_images_session_key)
            conn = put_flash(conn, :success, "Ad Created Successfully")
            redirect(conn, to: user_path(conn, :dashboard, "9110735"))
        else
            categories = Commercefacile.Ads.get_categories(:main_with_children)
                |> Commercefacile.Web.Serializers.AdController.Create.Categories.to_list(:select)
                # get locations
            locations = Commercefacile.Locations.get_regions(:togo, :with_cities)
                |> Commercefacile.Web.Serializers.AdController.Create.Locations.to_list(:select)
            conn
            |> get_ad_images
            |> assign(:changeset, %{changeset | action: :validate})
            |> render("create.html", categories: categories, locations: locations, conditions: @ad_conditions)
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

    # def edit(conn, _params) do
    #     # ad = get_ad
    #     render conn, "show.html"
    # end

    # def delete(conn, _params) do
    #     # ad = get_ad
    #     render conn, "show.html"
    # end
end