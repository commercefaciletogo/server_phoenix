defmodule Commercefacile.Repo.Migrations.AddReportedAdsTable do
  use Ecto.Migration

  def change do
    create table(:reported_ads) do
      add :user_id, references(:users)
      add :ad_id, references(:ads)

      timestamps()
    end
  end
end
