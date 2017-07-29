defmodule Commercefacile.Repo.Migrations.AddLocationsTable do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :uuid, :string
      add :name, :string
      add :svg, :text 
      add :parent_id, references(:locations), null: true
      add :country_id, references(:countries)

      timestamps()
    end
  end
end
