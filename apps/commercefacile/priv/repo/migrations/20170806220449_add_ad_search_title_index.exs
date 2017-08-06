defmodule Commercefacile.Repo.Migrations.AddAdSearchTitleIndex do
  use Ecto.Migration

  def up do
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX ads_title_trgm_index ON ads USING gin (title gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX ads_title_trgm_index;"
  end
end
