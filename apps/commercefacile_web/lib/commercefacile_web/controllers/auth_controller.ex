defmodule Commercefacile.Web.AuthController do
    use Commercefacile.Web, :controller

    plug Guardian.Plug.EnsureAuthenticated, [handler: Commercefacile.Web.ErrorController] 
    when action in [:logout]

    alias Commercefacile.Accounts.Verification.Code

    # ✓
    def get_register(conn, _params) do
        conn
        |> assign(:changeset, Commercefacile.Accounts.Embededs.changeset(:register))
        |> render("register.html")
    end
    def post_register(conn, %{"register" => register}) do
        case Commercefacile.Accounts.new_user(register) do
            {:ok, user, code} ->
                conn = put_session(conn, :code_reference, code.reference)
                conn = put_session(conn, :user_in_register_mode, user.uuid)
                conn = put_status(conn, 303)
                redirect(conn, to: auth_path(conn, :get_code))
            {:error, :invalid_data, changeset} -> 
                conn
                |> put_status(400)
                |> validate(changeset)
                |> render("register.html")
            {:error, :internal_error} ->
                # redirect(conn, to: auth_path(conn, :get_register))
                put_view(conn, Commercefacile.Web.ErrorView)
                |> put_status(500)
                |> render("500.html")
            {:error, changeset} ->
                conn
                |> put_status(400)
                |> assign(:changeset, changeset)
                |> render("register.html")
        end
    end

    def get_reset_verify(conn, _params) do
        conn
        |> put_session(:reset_mode, true)
        |> put_status(303)
        |> redirect(to: auth_path(conn, :get_verify))
    end

    def get_new_verify(conn, _params) do
        conn
        |> put_session(:new_phone, true)
        |> put_status(303)
        |> redirect(to: auth_path(conn, :get_verify))
    end

    # ✓
    def get_verify(conn, _params) do
        reset_mode = get_session(conn, :reset_mode)
        new_phone = get_session(conn, :new_phone)
        if reset_mode || new_phone do
            conn
            |> assign(:changeset, Commercefacile.Accounts.Embededs.changeset(:verify))
            |> render("verify.html")
        else
            conn
            |> put_status(404)
            |> put_view(Commercefacile.Web.ErrorView)
            |> render("404.html")
        end
    end
    def post_verify(conn, %{"verify" => verify}) do
        case Commercefacile.Accounts.verify_phone(verify) do
            {:ok, user, code} -> 
                conn = put_session(conn, :code_reference, code.reference)
                conn = if get_session(conn, :reset_mode), do: put_session(conn, :user_in_reset_mode, user.uuid), else: conn
                conn = if get_session(conn, :new_phone), do: put_session(conn, :user_in_new_phone_mode, user.uuid), else: conn
                put_status(conn, 303)
                |> redirect(to: auth_path(conn, :get_code))
            {:error, :invalid_data, changeset} ->
                conn
                |> put_status(400)
                |> validate(changeset)
                |> render("verify.html")
            {:error, :not_found} ->
                conn
                |> put_status(400)
                |> put_flash(:error, "Phone number is not found")
                |> assign(:changeset, Commercefacile.Accounts.Embededs.changeset(:verify))
                |> render("verify.html")
            {:error, :internal_error} ->
                conn
                |> put_status(500)
                |> put_view(Commercefacile.Web.ErrorView)
                |> put_flash(:error, "Something went wrong.")
                |> render("500.html")
        end
    end

    # ✓
    def get_code(conn, _params) do
        user_uuid = get_session(conn, :user_in_reset_mode) || get_session(conn, :user_in_register_mode) || get_session(conn, :user_in_new_phone_mode)
        refercence = get_session(conn, :code_reference)
        if user_uuid && refercence do
            conn
            |> assign(:changeset, Commercefacile.Accounts.Embededs.changeset(:code))
            |> render("code.html")
        else
            conn
            |> put_status(404)
            |> put_view(Commercefacile.Web.ErrorView)
            |> render("404.html")
        end
    end
    def post_code(conn, %{"code" => code}) do
        if refercence = get_session(conn, :code_reference) do
            case Commercefacile.Accounts.verify_code(%{code_changeset: code, reference: refercence}) do
                {:ok, user} ->
                    conn = Guardian.Plug.sign_in(conn, user)
                    conn = delete_session(conn, :code_reference)
                    case get_session(conn, :guest) do
                        %Commercefacile.Accounts.Guest{ad: %Commercefacile.Accounts.Guest.Ad{images: [_|_]} = ad} ->
                            {:ok, _ad} = Commercefacile.Ads.new_ad(ad, user)
                            delete_session(conn, :guest)
                            |> put_status(303)
                            |> redirect(to: user_path(conn, :dashboard, user.phone))
                        nil ->
                            if get_session(conn, :reset_mode) do
                                conn
                                |> delete_session(:reset_mode)
                                |> put_status(303)
                                |> redirect(to: auth_path(conn, :get_reset))
                                |> halt()
                            end
                            if get_session(conn, :new_phone) do
                                conn
                                |> delete_session(:new_phone)
                                |> put_status(303)
                                |> redirect(to: user_path(conn, :settings, user.phone))
                                |> halt()
                            end
                            conn = put_status(conn, 303)
                            redirect(conn, to: logged_in_path(conn, user.phone))
                    end
                {:error, :invalid_data, changeset} ->
                    conn
                    |> put_status(400)
                    |> validate(changeset)
                    |> render("code.html")
                {:error, :not_found, changeset} ->
                    conn
                    |> put_status(400)
                    |> put_flash(:error, "Code is invalid")
                    |> render("code.html", changeset: changeset)
            end
        else
            conn = put_status(conn, 303)
            redirect(conn, to: "/")
        end
    end

    # ✓
    def get_login(conn, _params) do
        conn
        |> assign(:changeset, Commercefacile.Accounts.Embededs.changeset(:login))
        |> guest?(:login)
        |> render("login.html")
    end
    def post_login(conn, %{"login" => login}) do
        case Commercefacile.Accounts.find_and_confirm_password(login) do
            {:ok, %{phone: phone} = user} ->
                conn = Guardian.Plug.sign_in(conn, user)
                case get_session(conn, :guest) do
                    %Commercefacile.Accounts.Guest{ad: %Commercefacile.Accounts.Guest.Ad{images: [_|_]} = ad} ->
                        case Commercefacile.Ads.new_ad(ad, user) do
                            {:ok, _ad} -> 
                                delete_session(conn, :guest)
                                |> put_status(303)
                                |> redirect(to: user_path(conn, :dashboard, phone))
                            {:error, :internal_error} ->
                                put_status(conn, 500)
                                |> put_view(Commercefacile.Web.ErrorView)
                                |> render("500.html")
                        end
                    nil -> 
                        put_status(conn, 303)
                        |> redirect(to: user_path(conn, :dashboard, user.phone))
                end
            {:error, :invalid_data, changeset} ->
                conn
                |> put_status(:bad_request)
                |> validate(changeset)
                |> render("login.html")
            {:error, :not_found, changeset} ->
                conn
                |> put_status(:bad_request)
                |> put_flash(:error, "Wrong Phone / Password")
                |> assign(:changeset, changeset)
                |> render("login.html")
            {:error, :no_match, changeset} ->
                conn
                |> put_status(:bad_request)
                |> put_flash(:error, "Wrong Phone / Password")
                |> assign(:changeset, changeset)
                |> render("login.html")
            {:error, :not_verified, phone} ->
                conn
                |> put_status(:bad_request)
                |> put_flash(:error, "Account is not yet verified, kindly verify it.")
                |> put_session(:unverified_phone, phone)
                |> redirect(to: auth_path(conn, :get_verify))
            {:error, :not_active, changeset} ->
                conn
                |> put_status(:locked)
                |> put_flash(:error, "Account is deactivated for some reason, kindly contact Administration for more info.")
                |> assign(:changeset, changeset)
                |> render("login.html")
        end
    end

    # ✓
    def get_reset(conn, _params) do
        in_mode? = get_session(conn, :reset_mode)
        user_uuid = get_session(conn, :user_in_reset_mode)
        if in_mode? && user_uuid do
            conn
            |> assign(:changeset, Commercefacile.Accounts.Embededs.changeset(:reset))
            |> render("reset.html")
        else
            conn
            |> put_status(:not_found)
            |> put_view(Commercefacile.Web.ErrorView)
            |> render("404.html")
        end
        
    end
    def post_reset(conn, %{"reset" => reset}) do
        if user_uuid = get_session(conn, :user_in_reset_mode) do
            case Commercefacile.Accounts.reset_user_password(reset, user_uuid) do
                {:ok, user} ->
                    Guardian.Plug.sign_in(conn, user)
                    |> put_status(303)
                    |> redirect(to: logged_in_path(conn, user.phone))
                {:error, :invalid_data, changeset} ->
                    validate(conn, changeset)
                    |> render("reset.html")
                {:error, changeset} ->
                    validate(conn, changeset)
                    |> render("reset.html")
            end
        else
            put_status(conn, 303)
            |> redirect(to: NavigationHistory.last_path(conn))
        end
    end

    def logout(conn, _params) do
        conn
        |> Guardian.Plug.sign_out
        |> put_status(303)
        |> redirect(to: "/")
    end

    defp guest?(conn, :login) do
        case get_session(conn, :login_phone) do
            nil -> conn
            phone -> 
                changeset = conn.assigns["changeset"]
                changeset = Ecto.Changeset.put_change(changeset, :phone, phone)
                assign(conn, :changeset, changeset)
        end
    end

    defp validate(conn, changeset) do
        assign(conn, :changeset, %{changeset | action: :validate})
    end

    defp logged_in_path(conn, slug) do
        get_session(conn, :intended) || user_path(conn, :dashboard, slug)
    end
end