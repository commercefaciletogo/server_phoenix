defmodule Commercefacile.Locations.Country do
    use Ecto.Schema
    import Ecto.Changeset

    schema "countries" do
        field :name, :string
        field :uuid, :string
        field :code, :string

        timestamps()
    end
end