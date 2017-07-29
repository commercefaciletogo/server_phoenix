defmodule Commercefacile.Locations do
    import Ecto.Query, only: [from: 2]

    alias Commercefacile.Repo
    alias Commercefacile.Locations.{
        Location, Country
    }

    def get_country(:togo), do: Repo.get Country, 1

    def get_map(:togo) do
        get_country(:togo)
        |> do_get_map
    end

    def get_regions(:togo) do
        get_country(:togo)
        |> do_get_regions
    end
    def get_regions(:togo, :with_cities) do
        get_country(:togo)
        |> do_get_regions(:with_cities)
    end

    def get_cities(limit, :togo) do
        get_country(:togo)
        |> do_get_cities(limit)
    end


    defp do_get_map(%Country{id: id}) do
        q = from l in Location,
            where: l.country_id == ^id,
            where: is_nil(l.parent_id),
            where: not is_nil(l.svg)
        Repo.all(q)
    end

    defp do_get_regions(%Country{id: id}) do
        q = from l in Location,
            where: l.country_id == ^id,
            where: is_nil(l.parent_id)
        Repo.all(q)
    end
    defp do_get_regions(%Country{id: id}, :with_cities) do
        q = from l in Location,
            where: l.country_id == ^id,
            where: is_nil(l.parent_id),
            preload: :children
        Repo.all(q)
    end

    defp do_get_cities(%Country{id: id}, limit) do
        q = from l in Location,
            where: l.country_id == ^id,
            where: not is_nil(l.parent_id),
            limit: ^limit 
        Repo.all(q)
    end
end