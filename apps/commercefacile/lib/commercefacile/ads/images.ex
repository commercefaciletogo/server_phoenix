defmodule Commercefacile.Ads.Images do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key {:id, Commercefacile.Type.EctoKsuid, autogenerate: true}

    schema "ad_images" do
        field :path, :string
        field :name, :string
        field :main, :boolean
        field :size, :string

        belongs_to :ad, Commercefacile.Ads.Ad, type: :string

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:path, :name, :main, :size, :ad_id])
        |> validate_required([:path, :name, :main, :size, :ad_id])
    end
end