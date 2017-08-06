defmodule Commercefacile.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true
      add :uuid, :string
      add :name, :string
      add :password, :string
      add :phone, :string
      add :active, :boolean, default: false
      add :verified, :boolean, default: false
      add :email, :string
      add :location_id, references(:locations)

      timestamps()
    end

    create unique_index(:users, [:uuid, :phone])
    create index(:users, [:location_id])
  end
end
