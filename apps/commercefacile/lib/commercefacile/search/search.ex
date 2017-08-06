defmodule Commercefacile.Search do

    defstruct [query: nil, 
        pagination: %{limit: 10, step: 1, offset: 0, count: nil, prev: false, next: false}, 
        result: [], 
        sort: [],
        search: %{term: nil, columns: []},
        filter: [],
        assoc_filter: []
    ]

    @opaque t :: %__MODULE__{}

    @type error :: {:error, :invalid_query}

    @error {:error, :invalid_query}

    alias Commercefacile.Search

    alias Commercefacile.Repo

    import Ecto.Query

    @default_limit 10
    @default_step 1

    @spec search(query :: Ecto.Queryable.t | t, term :: String.t, fields :: [atom]) :: t | error
    def search(%Search{query: nil}, _term, _fields), do: @error
    def search(%Search{query: query} = s, term, fields) do
        Map.merge(s, search(query, term, fields), fn k, v1, v2 -> 
            case k do
                :search -> v2
                :query -> v2
                _ -> v1
            end
        end)
    end
    def search(query, term, fields) do
        query = Enum.reduce(fields, query, fn field, query ->  
            from q in query, or_where: fragment("? % ?", field(q, ^field), ^term)
        end)
        %Commercefacile.Search{search: %{term: term, fields: fields}, query: query}
    end



    @spec filter(query :: Ecto.Queryable.t | t, filters :: [field: value :: term])  :: t | error
    def filter(%Search{query: nil}, _filters), do: @error
    def filter(%Search{query: query} = s, filters) do
        Map.merge(s, filter(query, filters), fn k, v1, v2 -> 
            case k do
                :filter -> v2
                :query -> v2
                _ -> v1
            end
        end)
    end
    def filter(query, filters) do
        query = Enum.reduce(filters, query, fn {key, value}, query ->
            from q in query, where: field(q, ^key) == ^value
        end)
        %Commercefacile.Search{query: query, filter: filters}
    end

    @spec assoc_filter(query :: Ecto.Queryable.t | t, filters :: [assoc: value :: {key :: atom, value :: term} | {nested_assoc :: atom, key :: atom, value :: term}])  :: t | error
    def assoc_filter(%Search{query: nil}, _filters), do: @error
    def assoc_filter(%Search{query: query} = s, filters) do
        Map.merge(s, assoc_filter(query, filters), fn k, v1, v2 -> 
            case k do
                :assoc_filter -> v2
                :query -> v2
                _ -> v1
            end
        end)
    end
    def assoc_filter(query, filters) do
        query = Enum.reduce(filters, query, &_build_assoc_query/2)
        %Commercefacile.Search{query: query, assoc_filter: filters}
    end

    defp _build_assoc_query({assoc, {key, value}}, query) do
        from q in query, 
            join: a in assoc(q, ^assoc),
            where: field(a, ^key) == ^value,
            preload: [{^assoc, a}]
    end
    defp _build_assoc_query({assoc, {nested_assoc, {nested_nested_assoc, key}, value}}, query) do
        from q in query, 
            join: a in assoc(q, ^assoc),
            join: n_a in assoc(a, ^nested_assoc),
            join: n_n_a in assoc(n_a, ^nested_nested_assoc),
            where: field(n_n_a, ^key) == ^value,
            preload: [{^assoc, {a, [{^nested_assoc, {n_a, [{^nested_nested_assoc, n_n_a}]}}]}}]
    end
    defp _build_assoc_query({assoc, {nested_assoc, key, value}}, query) do
        from q in query, 
            join: a in assoc(q, ^assoc),
            join: n_a in assoc(a, ^nested_assoc),
            where: field(n_a, ^key) == ^value,
            preload: [{^assoc, {a, [{^nested_assoc, n_a}]}}]
    end


    @spec sort(query :: Ecto.Queryable.t | t, fields_with_order :: [order: field :: atom])  :: t | error
    def sort(%Search{query: nil}, _fields_with_order), do: @error
    def sort(%Search{query: query} = s, fields_with_order) do
        Map.merge(s, sort(query, fields_with_order), fn k, v1, v2 -> 
            case k do
                :sort -> v2
                :query -> v2
                _ -> v1
            end
        end)
    end
    def sort(query, fields_with_order) do
        query = from(q in query, order_by: ^fields_with_order)
        %Commercefacile.Search{query: query, sort: fields_with_order}
    end



    @spec paginate(query :: Ecto.Queryable.t | t, opts :: list) :: t | error
    def paginate(query, opts \\ [])
    def paginate(%Search{query: nil}, _opts), do: @error 
    def paginate(%Search{query: query} = s, opts) do
        Map.merge(s, paginate(query, opts), fn k, v1, v2 -> 
            case k do
                :pagination -> v2
                :query -> v2
                :result -> v2
                _ -> v1
            end
        end)
    end
    def paginate(query, opts) do
        count = get_count(query)
        limit = Keyword.get(opts, :limit, @default_limit)
        step = Keyword.get(opts, :step, @default_step)
        offset = Keyword.get(opts, :offset, get_default_offset(limit, step, count))
        query = from q in query, limit: ^limit, offset: ^offset
        prev = prev?(count, step, limit)
        next = next?(count, step, limit)

        %Commercefacile.Search{
            query: query,
            result: Repo.all(query),
            pagination: %{
                prev: prev,
                step: step,
                limit: limit,
                offset: offset,
                count: count,
                next: next
            }
        }
    end



    @spec execute(query :: Ecto.Query.t | t) :: t | error
    def execute(%Search{query: nil}), do: @error
    def execute(%Search{query: query} = s) do
        Map.merge(s, paginate(query), fn k, v1, v2 -> 
            case k do
                :pagination -> v2
                :query -> v2
                :result -> v2
                _ -> v1
            end
        end)
    end
    def execute(query), do: paginate(query)

    @spec get_count(query :: Ecto.Queryable.t) :: integer
    defp get_count(query) do
         Ecto.Query.exclude(query, :limit)
            |> Repo.all |> length
    end

    def get_default_offset(limit, step \\ @default_step, count)
    def get_default_offset(_limit, 1, _count), do: 0
    def get_default_offset(limit, step, _count) do
        (limit * step) - limit
    end

    
    def next?(total, current_page, per_page), 
        do: (Float.ceil(total / per_page) |> round) > current_page   

    def prev?(_total, current_page, _per_page), do: current_page > 1
end