defmodule Commercefacile.Accounts do
    alias Commercefacile.Repo
    alias Commercefacile.Accounts
    alias Ecto.Multi

    @sms Application.get_env(:commercefacile, Commercefacile.Services) |> Keyword.get(:sms) |> Keyword.get(:engine)
    @sms_originator Application.get_env(:commercefacile, Commercefacile.Services) |> Keyword.get(:sms) |> Keyword.get(:originator)

    # ✓
    def new_user(%{} = data) do
        changeset = Commercefacile.Accounts.Embededs.changeset(data, :register)
        if changeset.valid? do
            result = 
                Multi.new
                |> Multi.insert(:register_user, Accounts.User.changeset(%Accounts.User{}, changeset.changes))
                |> Multi.run(:generate_code, fn %{register_user: user} -> 
                    Accounts.Verification.generate_code_for(user)
                end)
                |> Multi.run(:sms_code, fn %{register_user: user, generate_code: code} -> 
                    message = Accounts.Verification.code_sms_template(code.code)
                    {:ok, _} = @sms.text(@sms_originator, user.phone, message)
                    {:ok, code}
                end)
                |> Repo.transaction

            case result do
                {:ok, %{register_user: user, generate_code: code}} -> {:ok, user, code}
                {:error, :register_user, changeset, %{}} -> {:error, changeset}
                {:error, :generate_code, _, %{}} -> {:error, :internal_error, :code}
                {:error, :sms_code, _, %{}} -> {:error, :internal_error, :sms}
            end
        else
            {:error, :invalid_data, changeset}
        end
    end

    # ✓
    def new_guest(%{} = data) do
        {:ok, info} = Mapail.map_to_struct(data, Accounts.Guest.Information)
        {:ok, ad} = Mapail.map_to_struct(data, Accounts.Guest.Ad)
        %Accounts.Guest{
            info: info,
            ad: ad
        }
    end

    # ✓
    def phone_taken?(phone) do
        case Repo.get_by(Accounts.User, phone: format_phone(phone)) do
            nil -> false
            %Accounts.User{verified: false} -> {true, :unverified_user, phone}
            %Accounts.User{verified: true, active: false} -> {true, :inactive_user}
            %Accounts.User{verified: true, active: true} -> {true, :active_user}
        end
    end

    def user_location_set?(%Accounts.User{} = user) do
        user = Repo.preload(user, [:location])
        not is_nil(user.location)
    end

    # ✓
    def verify_phone(verify) do
        changeset = Accounts.Embededs.changeset(verify, :verify)
        if changeset.valid? do
            phone = Ecto.Changeset.get_change(changeset, :phone) |> format_phone
            with %Accounts.User{} = user <- Repo.get_by(Accounts.User, phone: phone),
                {:ok, %{code: digits} = code} <- Accounts.Verification.generate_code_for(user),
                {:ok, %{}} <- @sms.text(@sms_originator, phone, Accounts.Verification.code_sms_template(digits))
            do
                {:ok, user, code}
            else
                nil -> {:error, :not_found}
                {:error, _} -> {:error, :internal_error}
            end
        else
            {:error, :invalid_data, changeset}
        end
    end

    # ✓
    def verify_code(%{code_changeset: code, reference: reference}) do
        changeset = Accounts.Embededs.changeset(code, :code)
        if changeset.valid? do
            case Accounts.Verification.validate(%{code: Ecto.Changeset.get_change(changeset, :code), reference: reference}) do
                {:ok, %{user: user}} -> 
                    Repo.update(Ecto.Changeset.change(user, verified: true, active: true))
                {:error, :invalid_data} -> {:error, :not_found, changeset}
            end
        else
            {:error, :invalid_data, changeset}
        end
    end

    # ✓
    def find_and_confirm_password(%{} = login) do
        changeset = Accounts.Embededs.changeset(login, :login)
        if changeset.valid? do
            phone = Ecto.Changeset.get_change(changeset, :phone) |> format_phone
            password = Ecto.Changeset.get_change(changeset, :password)
            with %Accounts.User{verified: true, active: true} = user <- Repo.get_by(Accounts.User, phone: phone),
                true <- Accounts.User.confirms_password?(user, password)
            do
                {:ok, user}
            else
                nil -> {:error, :not_found, changeset}
                false -> {:error, :no_match, changeset}
                %Accounts.User{verified: false} -> {:error, :not_verified, login["phone"]}
                %Accounts.User{active: false} -> {:error, :not_active, changeset}
            end
        else
            {:error, :invalid_data, changeset}
        end
    end

    # ✓
    def change_user_password(%{reset: %{old_password: password} = reset, user: user}) do
        changeset = Accounts.Embededs.changeset(reset, :reset)
        if changeset.valid? do
            if Accounts.User.confirms_password?(user, password) do
                changes = Map.to_list(changeset.changes)
                user = Ecto.Changeset.change(user, changes)
                Repo.update(user)
            else
                {:error, :no_match, changeset}
            end
        else
            {:error, :invalid_data, changeset}
        end
    end

    # ✓
    def reset_user_password(reset, user_uuid) do
        case Repo.get_by(Accounts.User, uuid: user_uuid) do
            %Accounts.User{} = user -> reset_user_password(%{reset: reset, user: user}) 
            nil -> {:error, :not_found}
        end
    end
    def reset_user_password(%{reset: reset, user: user}) do
        changeset = Accounts.Embededs.changeset(reset, :reset)
        if changeset.valid? do
            changes = Map.to_list(changeset.changes)
            user = Ecto.Changeset.change(user, changes)
            Repo.update(user)
        else
            {:error, :invalid_data, changeset}
        end
    end

    def extract_errors(changeset) do
        Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
            Enum.reduce(opts, message, fn {key, value}, acc ->
                String.replace(acc, "%{#{key}}", to_string(value))
            end)
        end)
    end

    def format_phone("+" <> _ = phone) do
        String.replace(phone, "+", "00")
    end
    def format_phone("00" <> _ = phone), do: phone
end