defmodule Commercefacile.Ads.Category do
    use Ecto.Schema
    import Ecto.Changeset

    schema "categories" do
        field :uuid, :string
        field :name, :string
        
        field :icon, :string

        belongs_to :parent, Commercefacile.Ads.Category, foreign_key: :parent_id
        has_many :children, Commercefacile.Ads.Category, foreign_key: :parent_id

        timestamps()
    end
end