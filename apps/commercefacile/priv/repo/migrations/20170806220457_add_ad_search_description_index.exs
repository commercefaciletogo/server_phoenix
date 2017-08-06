defmodule Commercefacile.Repo.Migrations.AddAdSearchDescriptionIndex do
  use Ecto.Migration

  def up do
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX ads_description_trgm_index ON ads USING gin (description gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX ads_description_trgm_index;"
  end
end
