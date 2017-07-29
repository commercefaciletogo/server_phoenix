defmodule Commercefacile.Repo.Migrations.AddRejectedAdsTable do
  use Ecto.Migration

  def change do
    create table(:rejected_ads) do
      add :fields, :string
      add :ad_id, references(:ads)

      timestamps()
    end

    create index(:rejected_ads, [:ad_id])
  end
end
