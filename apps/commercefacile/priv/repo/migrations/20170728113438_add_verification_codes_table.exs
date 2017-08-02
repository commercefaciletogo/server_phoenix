defmodule Commercefacile.Repo.Migrations.AddVerificationCodesTable do
  use Ecto.Migration

  def change do
    create table(:verification_codes) do
      add :code, :string
      add :reference, :string
      add :user_id, references(:users), on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end
