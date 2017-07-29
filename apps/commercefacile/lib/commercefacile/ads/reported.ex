defmodule Commercefacile.Ads.Reported do
    use Ecto.Schema
    import Ecto.Changeset

    schema "reported_ads" do
        field :user_id, :integer
        field :ad_id, :integer

        timestamps()
    end
end