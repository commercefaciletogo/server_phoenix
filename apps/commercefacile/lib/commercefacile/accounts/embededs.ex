defmodule Commercefacile.Accounts.Embededs do
    alias Ecto.Changeset

    def changeset(params \\ %{}, type)
    def changeset(params, :login) do
        data = %{}
        types = %{phone: :string, password: :string}
        {%{}, types}
        |> Changeset.cast(params, Map.keys(types))
        |> Changeset.validate_required(Map.keys(types))
        |> format_phone
        |> Changeset.validate_length(:phone, is: 12)
    end
    def changeset(params, :register) do
        data = %{}
        types = %{phone: :string, 
                password: :string, 
                password_confirmation: :string, 
                name: :string, 
                terms: :boolean}
        {data, types}
        |> Changeset.cast(params, Map.keys(types))
        |> Changeset.validate_required(Map.keys(types))
        |> format_phone
        |> Changeset.validate_length(:phone, is: 12)
        |> Changeset.validate_length(:password, min: 7)
        |> Changeset.validate_confirmation(:password)
        |> Changeset.validate_acceptance(:terms)
    end
    def changeset(params, :info) do
        data = %{}
        types = %{phone: :string, name: :string, location_id: :integer, email: :string}
        {data, types}
        |> Changeset.cast(params, Map.keys(types))
        |> Changeset.validate_required([:phone, :name])
        |> Changeset.validate_format(:email, ~r/@/)
    end
    def changeset(params, :password) do
        data = %{}
        types = %{current_password: :string, 
                password: :string, 
                password_confirmation: :string}
        {data, types}
        |> Changeset.cast(params, Map.keys(types))
        |> Changeset.validate_required(Map.keys(types))
        |> Changeset.validate_length(:password, min: 7)
        |> Changeset.validate_confirmation(:password)
    end
    def changeset(params, :code) do
        data = %{}
        types = %{code: :string}
        {data, types}
        |> Changeset.cast(params, Map.keys(types))
        |> Changeset.validate_required([:code])
        |> Changeset.validate_length(:code, is: 6)
    end
    def changeset(params, :reset) do
        data = %{}
        types = %{password_confirmation: :string, password: :string}
        {data, types}
        |> Changeset.cast(params, Map.keys(types))
        |> Changeset.validate_required(Map.keys(types))
        |> Changeset.validate_length(:password, min: 7)
        |> Changeset.validate_confirmation(:password)
        |> Commercefacile.Accounts.User.hash_password
    end
    def changeset(params, :verify) do
        data = %{}
        types = %{phone: :string}
        {%{}, types}
        |> Changeset.cast(params, Map.keys(types))
        |> Changeset.validate_required(Map.keys(types))
        |> format_phone
        |> Changeset.validate_length(:phone, is: 12)
    end

    defp format_phone(changeset) do
        phone = Changeset.get_change(changeset, :phone)
        if phone do
            phone = String.replace(phone, " ", "")
            Changeset.put_change(changeset, :phone, phone)
        else
            changeset
        end
    end
end