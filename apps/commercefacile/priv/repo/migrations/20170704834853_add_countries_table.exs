defmodule Commercefacile.Repo.Migrations.AddCountriesTable do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string
      add :uuid, :string
      add :code, :string

      timestamps()
    end

    create index(:countries, [:code])
  end
end
