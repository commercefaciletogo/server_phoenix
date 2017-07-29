defmodule Commercefacile.Repo.Migrations.AddCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :uuid, :string
      add :name, :string
      add :parent_id, references(:categories), null: true
      add :icon, :string, null: true

      timestamps()
    end

    create unique_index(:categories, [:uuid])

    create index(:categories, [:parent_id])
  end
end
