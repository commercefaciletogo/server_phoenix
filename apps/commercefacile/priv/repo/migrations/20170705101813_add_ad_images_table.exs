defmodule Commercefacile.Repo.Migrations.AddAdImagesTable do
  use Ecto.Migration

  def change do
    create table(:ad_images, primary_key: false) do
      add :id, :string, primary_key: true
      add :path, :string
      add :name, :string
      add :main, :boolean
      add :size, :string
      add :ad_id, references(:ads, type: :string), on_delete: :delete_all, on_update: :update_all

      timestamps()
    end

    create index(:ad_images, [:ad_id])
  end
end
