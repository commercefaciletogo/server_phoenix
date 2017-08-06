defmodule Commercefacile.Web.Serializers.AdController.Create.Locations do
    use Remodel

    attribute :name
    attribute :subs

    def subs(%{id: id, name: name, children: []}) do
        [id, name]
    end
    def subs(%{children: children}) do
        Commercefacile.Web.Serializers.AdController.Create.Locations.Children.to_list(children)
    end

    def to_list(collections, :select) do
        collectable = fn 
            %{name: name, children: [], id: id} -> 
                {"#{name}", [[key: name, value: id]]}
            %{name: name, children: children, id: _id} ->
                {"#{name}", Commercefacile.Web.Serializers.AdController.Create.Locations.Children.to_list(children, :select)}
        end
        Enum.into(collections, %{}, fn i -> collectable.(i) end)
    end

    defmodule Children do
        use Remodel

        attributes [:key, :value]

        def key(%{name: name}), do: name
        def value(%{id: id}), do: id

        def to_list(collections, :select) do
            Enum.into(collections, [], fn i -> 
                [key: i.name, value: i.id]
            end)
        end
    end
end