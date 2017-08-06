defmodule Commercefacile.Ads.Reported do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key {:id, Commercefacile.Type.EctoKsuid, autogenerate: true}

    schema "reported_ads" do
        field :user_id, :string
        field :ad_id, :string

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:user_id, :ad_id])
        |> validate_required([:user_id, :ad_id])
    end
end