defmodule Commercefacile.Repo.Migrations.AddAdsTable do
  use Ecto.Migration

  def change do
    create table(:ads, primary_key: false) do
      add :id, :string, primary_key: true
      add :uuid, :string
      add :code, :string
      
      add :title, :string
      add :condition, :string
      add :description, :text
      add :price, :integer
      add :negotiable, :boolean
      add :status, :string

      add :start_date, :utc_datetime, null: true
      add :end_date, :utc_datetime, null: true

      add :user_id, references(:users, type: :string), on_delete: :delete_all, on_update: :update_all
      add :category_id, references(:categories)

      timestamps()
    end

    create index(:ads, [:user_id, :category_id, :title])

    create unique_index(:ads, [:uuid, :code])
  end
end
