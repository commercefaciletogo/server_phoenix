defmodule Commercefacile.Ads.Rejected do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key {:id, Commercefacile.Type.EctoKsuid, autogenerate: true}

    schema "rejected_ads" do
        field :fields, :string

        belongs_to :ad, Commercefacile.Ads.Ad, type: :string

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:fields, :ad_id])
        |> validate_required([:fields, :ad_id])
    end
end