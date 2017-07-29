defmodule Commercefacile.Repo.Migrations.AddFavoritedAdsTable do
  use Ecto.Migration

  def change do
    create table(:favorited_ads) do
      add :user_id, references(:users)
      add :ad_id, references(:ads)

      timestamps()
    end
  end
end
