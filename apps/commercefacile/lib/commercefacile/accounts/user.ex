defmodule Commercefacile.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
        field :uuid, :string
        field :name, :string
        field :password, :string
        field :phone, :string
        field :active, :boolean
        field :email, :string
        field :verified, :boolean

        belongs_to :location, Commercefacile.Locations.Location

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:name, :password, :phone, :email])
        |> validate_required([:name, :password, :phone])
        |> validate_format(:email, ~r/@/)
        |> unique_constraint(:email)
        |> format_phone
        |> add_uuid
        |> hash_password
    end

    defp add_uuid(changeset), do: put_change(changeset, :uuid, Ksuid.generate())

    defp format_phone(changeset) do
        if changeset.valid? do
            p1 = get_change changeset, :phone
            p2 = Commercefacile.Accounts.format_phone p1
            put_change changeset, :phone, p2
        else
            changeset
        end
    end

    def hash_password(changeset) do
        if changeset.valid? do
            password = get_change(changeset, :password)
            hash = Comeonin.Bcrypt.hashpwsalt(password)
            put_change(changeset, :password, hash)
        else
            changeset
        end
    end

    def confirms_password?(%Commercefacile.Accounts.User{password: hashed_password}, password) do
        Comeonin.Bcrypt.checkpw(password, hashed_password)
    end
end