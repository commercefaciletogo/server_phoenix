defmodule Commercefacile.Web.AdController do
    use Commercefacile.Web, :controller

    alias Commercefacile.Web.Serializers.AdController, as: Serializer

    plug Guardian.Plug.EnsureAuthenticated, [handler: Commercefacile.Web.ErrorController]
    when action in [:private_save, :edit, :update, :delete]

    @ad_conditions [[key: "new", value: "Nouveau"], [key: "used", value: "Utilisé"]]
    @ad_images_session_key :ad_images

    def index(conn, params) do
        %{result: ads, pagination: paginate} = 
            Commercefacile.Ads.list(Map.merge(params, %{"status" => :online}))
        ads = Serializer.Index.Ad.to_map(ads)
        conn = add_fixtures(conn, :list)
        conn = assign(conn, :ads, ads)
        conn = assign(conn, :paginate, paginate)
        render conn, "index.html"
    end

    def create(conn, _params) do
        conn = case Guardian.Plug.current_resource(conn) do
            nil -> 
                assign(conn, :post_action, ad_path(conn, :save))
                |> assign(:changeset, Commercefacile.Ads.Ad.form_changeset(:guest))
            %Commercefacile.Accounts.User{} = user -> 
                change_type = if Commercefacile.Accounts.user_location_set?(user), do: :private, else: :private_with_location
                assign(conn, :post_action, ad_path(conn, :private_save))
                |> assign(:changeset, Commercefacile.Ads.Ad.form_changeset(change_type))
        end

        get_ad_images(conn)
        |> add_fixtures(:select)
        |> assign(:edit_mode, false)
        |> assign(:post_method, :post)
        |> render("create.html")
    end

    def save(conn, %{"ad" => %{"phone" => phone} = ad}) do
        # make sure of no invalid data
        images = get_session(conn, @ad_images_session_key) || []
        ad = Map.merge(ad, %{"images" => images})
        changeset = Commercefacile.Ads.Ad.form_changeset(ad, :guest)
        if changeset.valid? do
            conn = put_session(conn, :guest, Commercefacile.Accounts.new_guest(ad))
            # check phone is taken
            case Commercefacile.Accounts.phone_taken?(phone) do
                false -> 
                    {:ok, user, %{reference:  reference}} = Commercefacile.Accounts.new_user(ad)
                    put_session(conn, :user_in_register_mode, user)
                    |> put_session(:code_reference, reference)
                    |> redirect(to: auth_path(conn, :get_code))
                {true, :unverified_user, phone} -> 
                    put_flash(conn, :info, "Verify your phone to countinue")
                    |> put_session(:unverified_phone, phone)
                    |> redirect(to: auth_path(conn, :get_verify))
                {true, :inactive_user} -> 
                    put_status(conn, 400)
                    |> put_flash(:info, "Phone belongs to inactive account, contact adminst.. or new account")
                    |> assign(:post_action, :save)
                    |> assign(:post_method, :post)
                    |> assign(:edit_mode, false)
                    |> assign(:changeset, changeset)
                    |> render("create.html")
                {true, :active_user} -> 
                    put_session(conn, :login_phone, phone)
                    |> redirect(to: auth_path(conn, :get_login))
            end
        else
            IO.inspect changeset
            put_status(conn, 400)
            |> get_ad_images
            |> assign(:changeset, %{changeset | action: :validate})
            |> assign(:post_action, :save)
            |> assign(:post_method, :post)
            |> assign(:edit_mode, false)
            |> add_fixtures(:select)
            |> render("create.html")
        end
    end

    def private_save(conn, %{"ad" => ad} = _params) do
        user = Guardian.Plug.current_resource(conn)
        # IO.inspect params
        images = get_session(conn, @ad_images_session_key) || []
        ad = Map.merge(ad, %{"images" => images})
        # IO.inspect ad
        case Commercefacile.Ads.new_ad(ad, user) do
            {:ok, _} -> 
                conn
                |> redirect(to: user_path(conn, :dashboard, user.phone))
            {:error, :invalid_data, changeset} ->
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

    def show(conn, %{"uuid" => uuid}) do
        user = Guardian.Plug.current_resource(conn)
        case Commercefacile.Ads.get_ad(uuid: uuid, status: :online) do
            {:error, :not_found} -> 
                put_status(conn, :not_found)
                |> put_view(Commercefacile.Web.ErrorView)
                |> render("404.html")
            {:ok, ad, author} -> 
                assign(conn, :ad, Serializer.Show.Ad.to_map(ad, scope: user))
                |> assign(:author, Serializer.Show.Author.to_map(author))
                |> render("show.html")
        end
    end

    def edit(conn, %{"uuid" => uuid}) do
        user = Guardian.Plug.current_resource(conn)
        case Commercefacile.Ads.get_ad(uuid: uuid, user: user) do
            {:error, :not_found} -> 
                put_status(conn, :not_found)
                |> put_view(Commercefacile.Web.ErrorView)
                |> render("404.html")
            {:ok, ad} -> 
                %{uuid: uuid, rejecteds: {fields, locales}, images: images} = ad = Serializer.Edit.Ad.to_map(ad)

                assign(conn, :changeset, Commercefacile.Ads.Ad.form_changeset(ad, :private))
                |> add_fixtures(:select)
                |> assign(:rejecteds, locales || [])
                |> assign(:rejected_fields, fields || [])
                |> assign(:edit_mode, true)
                |> assign(:post_action, ad_path(conn, :update, uuid))
                |> assign(:post_method, :put)
                |> put_ad_images(images)
                |> render("create.html")
        end
    end

    def update(conn, %{"uuid" => uuid, "ad" => ad}) do
        user = Guardian.Plug.current_resource(conn)
        # sync images
        images = get_session(conn, @ad_images_session_key) || []
        ad = Map.merge(ad, %{"images" => images})
        
        case Commercefacile.Ads.edit_ad(uuid, ad, user) do
            {:error, :invalid_data, changeset} ->
                IO.inspect {:invalid_data, changeset}
                conn
                |> put_status(400)
                |> get_ad_images
                |> assign(:changeset, %{changeset | action: :validate})
                |> add_fixtures(:select)
                |> assign(:edit_mode, true)
                |> assign(:post_action, ad_path(conn, :update, uuid))
                |> assign(:post_method, :put)
                |> render("create.html")
            {:error, changeset} ->
                IO.inspect {:error, changeset}
                conn
                |> put_status(400)
                |> get_ad_images
                |> assign(:changeset, changeset)
                |> assign(:edit_mode, true)
                |> assign(:post_action, ad_path(conn, :update, uuid))
                |> assign(:post_method, :put)
                |> add_fixtures(:select)
                |> render("create.html")
            {:ok, _} -> 
                redirect(conn, to: user_path(conn, :dashboard, user.phone))
        end
    end

    def favorite(conn, %{"uuid" => uuid}) do
        
    end

    def unfavorite(conn, %{"uuid" => uuid}) do
        
    end

    def report(conn, %{"uuid" => uuid}) do
        
    end

    def unreport(conn, %{"uuid" => uuid}) do
        
    end

    def delete(conn, %{"uuid" => uuid}) do
        user = Guardian.Plug.current_resource(conn)
        case Commercefacile.Ads.delete_ad(uuid: uuid, user: user) do
            {:error, :not_found} -> 
                put_status(conn, :not_found)
                |> put_view(Commercefacile.Web.ErrorView)
                |> render("404.html")
            {:ok, _} -> 
                redirect(conn, to: user_path(conn, :dashboard, user.phone))
        end
    end

    defp add_fixtures(conn, :select) do
        categories = Commercefacile.Ads.get_categories(:main_with_children)
            |> Serializer.Create.Categories.to_list(:select)
            # get locations
        locations = Commercefacile.Locations.get_regions(:togo, :with_cities)
            |> Serializer.Create.Locations.to_list(:select)

        assign(conn, :locations, locations)
        |> assign(:categories, categories)
        |> assign(:conditions, @ad_conditions)
    end
    defp add_fixtures(conn, :list) do
        # get categories
        categories = Commercefacile.Ads.get_categories(:main_with_children)
            |> Serializer.Index.Categories.to_map
        # get locations
        locations = Commercefacile.Locations.get_regions(:togo, :with_cities)
            |> Serializer.Index.Locations.to_map
        assign(conn, :locations, locations)
        |> assign(:categories, categories)
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

    defp put_ad_images(conn, images) do
        assign(conn, :images, images)
        |> put_session(@ad_images_session_key, images)
    end
end