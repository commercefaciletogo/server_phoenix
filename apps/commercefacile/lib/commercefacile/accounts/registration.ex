defmodule Commercefacile.Accounts.Registration do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
        field :name, :string
        field :phone, :string
        field :password, :string
        field :password_confirmation, :string
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:name, :phone, :password, :password_confirmation])
        |> validate_required([:name, :phone, :password, :password_confirmation])
        |> validate_length(:name, min: 2)
        |> validate_confirmation(:password)
    end
end