defmodule Commercefacile.Repo.Migrations.AddRejectedAdsTable do
  use Ecto.Migration

  def change do
    create table(:rejected_ads, primary_key: false) do
      add :id, :string, primary_key: true
      add :fields, :string
      add :ad_id, references(:ads, type: :string), on_delete: :delete_all, on_update: :update_all

      timestamps()
    end

    create index(:rejected_ads, [:ad_id])
  end
end
