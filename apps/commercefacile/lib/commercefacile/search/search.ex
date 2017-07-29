defmodule Commercefacile.Search do
    defstruct schema: Commercefacile.Ad, fields: [:title], relations: [:category],
        term: :nothing, 
        pagination: %{per_page: 15, current_page: 1}, 
        sort: %{key: :date, direction: :desc}, 
        filter: %{location: :all, category: :all},
        query: nil

    alias Commercefacile.Search

    @search_type "ilike"

    def new(term, opts \\ [])

    def new(:nothing, []), do: %Search{}
    def new(term, []), do: %Search{term: term}

    def new(term, [{:filter, %{location: location, category: nil}}]), do: %Search{term: term,filter: %{location: location, category: :all}}
    def new(term, [{:filter, %{location: nil, category: category}}]), do: %Search{term: term, filter: %{location: :all, category: category}}
    def new(term, [{:filter, %{location: _location, category: _category} = filter}]), do: %Search{term: term, filter: filter}

    def new(term, [{:sort, %{key: :date, direction: :asc}}]), do: new(term)
    def new(term, [{:sort, %{key: :date, direction: :desc} = sort}]), do: %Search{term: term, sort: sort}
    def new(term, [{:sort, %{key: :price, direction: :asc} = sort}]), do: %Search{term: term, sort: sort}
    def new(term, [{:sort, %{key: :price, direction: :desc} = sort}]), do: %Search{term: term, sort: sort}

    def new(term, [{:pagination, %{per_page: 15, current_page: 1}}]), do: new(term)
    def new(term, [{:pagination, %{per_page: _per_page, current_page: _current_page} = pagination}]), do: %Search{term: term, pagination: pagination}

    def new(term, [{:filter, %{location: _, category: _} = filter}, {:sort, %{key: _, direction: _} = sort}]) do
        filter_search = new(term, filter: filter)
        sort_search = new(term, sort: sort)
        %Search{term: term, filter: filter_search.filter, sort: sort_search.sort}
    end

    def new(term, [{:filter, %{location: _, category: _} = filter}, {:pagination, %{per_page: _, current_page: _} = pagination}]) do
        filter_search = new(term, filter: filter)
        pagination_search = new(term, pagination: pagination)
        %Search{term: term, filter: filter_search.filter, pagination: pagination_search.pagination}
    end

    def new(term, [{:pagination, %{per_page: _, current_page: _} = pagination}, {:sort, %{key: _, direction: _} = sort}]) do
        sort_search = new(term, sort: sort)
        pagination_search = new(term, pagination: pagination)
        %Search{term: term, pagination: pagination_search.pagination, sort: sort_search.sort}
    end

    def new(term, [{:filter, %{location: _, category: _} = filter}, {:sort, %{key: _, direction: _} = sort}, {:pagination, %{per_page: _, current_page: _} = pagination}]) do
        filter_search = new(term, filter: filter)
        sort_search = new(term, sort: sort)
        pagination_search = new(term, pagination: pagination)
        %Search{term: term, filter: filter_search.filter, sort: sort_search.sort, pagination: pagination_search.pagination}
    end

    def querify(%Search{schema: _schema} = search) do
        rummage = do_rummage_map(search)
        rummage
        # {queryable, _rummage} = Rummage.Ecto.rummage(schema, rummage)
        # %{search | query: queryable}
    end

    def run(%Search{query: query}) 
    when query != nil
    do
        # perform the search
    end

    defp do_rummage_map(%Search{fields: [field1]} = search) do
        %{"search" => %{
            Atom.to_string(field1) => %{
                "assoc" => Enum.map(search.relations, &(Atom.to_string(&1))),
                "search_type" => @search_type,
                "search_term" => search.term
            }
        }, "paginate" => %{
            "per_page" => search.pagination.per_page,
            "page" => search.pagination.current_page
        }, "sort" => %{
            "assoc" => [],
            "field" => "#{Atom.to_string(search.sort.key)}.#{Atom.to_string(search.sort.direction)}.ci"
        }
        # , "filter" => %{
        #     "location" => search.filter.location,
        #     "category" => search.filter.category
        # }
    }
    end
end