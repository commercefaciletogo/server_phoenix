defmodule Commercefacile.Ads.Rejected do
    use Ecto.Schema
    import Ecto.Changeset

    schema "rejected_ads" do
        field :fields, :string

        belongs_to :ad, Commercefacile.Ads.Ad

        timestamps()
    end
end