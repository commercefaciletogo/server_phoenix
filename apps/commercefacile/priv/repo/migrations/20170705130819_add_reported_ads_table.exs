defmodule Commercefacile.Repo.Migrations.AddReportedAdsTable do
  use Ecto.Migration

  def change do
    create table(:reported_ads) do
      add :user_id, references(:users), on_delete: :delete_all, on_update: :update_all
      add :ad_id, references(:ads), on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end
