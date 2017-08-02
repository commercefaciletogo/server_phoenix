defmodule Commercefacile.Ads.Favorited do
    use Ecto.Schema
    import Ecto.Changeset

    schema "favorited_ads" do
        field :user_id, :integer
        field :ad_id, :integer

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:user_id, :ad_id])
        |> validate_required([:user_id, :ad_id])
    end
end