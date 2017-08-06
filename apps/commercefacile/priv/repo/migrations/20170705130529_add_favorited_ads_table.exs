defmodule Commercefacile.Repo.Migrations.AddFavoritedAdsTable do
  use Ecto.Migration

  def change do
    create table(:favorited_ads, primary_key: false) do
      add :id, :string, primary_key: true
      add :user_id, references(:users, type: :string), on_delete: :delete_all, on_update: :update_all
      add :ad_id, references(:ads, type: :string), on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end
