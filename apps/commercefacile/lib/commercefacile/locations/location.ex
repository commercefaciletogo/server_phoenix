defmodule Commercefacile.Locations.Location do
    use Ecto.Schema
    import Ecto.Changeset

    schema "locations" do
        field :uuid, :string
        field :name, :string

        field :svg, :string 

        belongs_to :parent, Commercefacile.Locations.Location, foreign_key: :parent_id
        has_many :children, Commercefacile.Locations.Location, foreign_key: :parent_id
        belongs_to :country, Commercefacile.Locations.Country

        timestamps()
    end
end