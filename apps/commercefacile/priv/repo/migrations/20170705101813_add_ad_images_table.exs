defmodule Commercefacile.Repo.Migrations.AddAdImagesTable do
  use Ecto.Migration

  def change do
    create table(:ad_images) do
      add :path, :string
      add :name, :string
      add :main, :boolean
      add :size, :string
      add :ad_id, references(:ads)

      timestamps()
    end

    create index(:ad_images, [:ad_id])
  end
end
