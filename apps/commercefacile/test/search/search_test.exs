defmodule Commercefacile.SearchTest do
    use Commercefacile.DataCase

    @default_schema Commercefacile.Ad
    
    describe "create new search with" do
        test "nothing" do
            term = :nothing
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :date, direction: :desc},
                filter: %{location: :all, category: :all},
                pagination: %{per_page: 15, current_page: 1}
            } = Commercefacile.Search.new(term)
        end
        test "term only" do
            term = "iphone 7"
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :date, direction: :desc},
                filter: %{location: :all, category: :all},
                pagination: %{per_page: 15, current_page: 1}
            } = Commercefacile.Search.new(term)
        end
        test "term and filter" do
            term = "iphone 7"        
            opts = [filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"}]
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :date, direction: :desc},
                filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"},
                pagination: %{per_page: 15, current_page: 1}
            } = Commercefacile.Search.new(term, opts)
        end
        test "term and sort" do
            term = "iphone 7"        
            opts = [sort: %{key: :price, direction: :asc}]
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :price, direction: :asc},
                filter: %{location: :all, category: :all},
                pagination: %{per_page: 15, current_page: 1}
            } = Commercefacile.Search.new(term, opts)
        end
        test "term and pagination" do
            term = "iphone 7"        
            opts = [pagination: %{per_page: 10, current_page: 3}]
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :date, direction: :desc},
                filter: %{location: :all, category: :all},
                pagination: %{per_page: 10, current_page: 3}
            } = Commercefacile.Search.new(term, opts)
        end
        # @tag :skip
        test "term, filter, sort" do
            term = "iphone 7"        
            opts = [filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"}, sort: %{key: :price, direction: :asc}]
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :price, direction: :asc},
                filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"},
                pagination: %{per_page: 15, current_page: 1}
            } = Commercefacile.Search.new(term, opts)
        end
        # @tag :skip
        test "term, filter, pagination" do
            term = "iphone 7"        
            opts = [filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"}, pagination: %{per_page: 10, current_page: 3}]
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :date, direction: :desc},
                filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"},
                pagination: %{per_page: 10, current_page: 3}
            } = Commercefacile.Search.new(term, opts)
        end
        # @tag :skip
        test "term, pgination, sort" do
            term = "iphone 7"        
            opts = [pagination: %{per_page: 10, current_page: 3}, sort: %{key: :price, direction: :asc}]
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :price, direction: :asc},
                filter: %{location: :all, category: :all},
                pagination: %{per_page: 10, current_page: 3}
            } = Commercefacile.Search.new(term, opts)
        end
        # @tag :skip
        test "term, filter, sort, pagination" do
            term = "iphone 7"        
            opts = [filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"}, sort: %{key: :price, direction: :asc}, pagination: %{per_page: 10, current_page: 3}]
            assert %Commercefacile.Search{
                term: ^term,
                schema: @default_schema,
                sort: %{key: :price, direction: :asc},
                filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"},
                pagination: %{per_page: 10, current_page: 3}
            } = Commercefacile.Search.new(term, opts)
        end
    end

    describe "convert search struct to map" do
        test " -> rummage" do
            term = "iphone 7"        
            opts = [filter: %{location: "fjadjfadkfjald", category: "fadjflkajsdlkfjakl"}, sort: %{key: :price, direction: :asc}, pagination: %{per_page: 10, current_page: 3}]
            search = Commercefacile.Search.new(term, opts)
            assert [] = Commercefacile.Search.querify(search)
        end
    end
end