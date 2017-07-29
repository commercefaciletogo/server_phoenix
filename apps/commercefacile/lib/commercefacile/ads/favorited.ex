defmodule Commercefacile.Ads.Favorited do
    use Ecto.Schema
    import Ecto.Changeset

    schema "favorited_ads" do
        field :user_id, :integer
        field :ad_id, :integer

        timestamps()
    end
end