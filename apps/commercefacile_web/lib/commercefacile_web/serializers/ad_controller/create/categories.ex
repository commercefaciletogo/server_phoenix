defmodule Commercefacile.Web.Serializers.AdController.Create.Categories do
    use Remodel

    attribute :name
    attribute :subs

    def subs(%{uuid: uuid, name: name, children: []}) do
        [uuid, name]
    end
    def subs(%{children: children}) do
        Commercefacile.Web.Serializers.AdController.Create.Categories.Children.to_list(children)
    end

    def to_list(collections, :select) do
        collectable = fn 
            %{name: name, children: [], uuid: uuid} -> 
                {"#{name}", [[key: name, value: uuid]]}
            %{name: name, children: children, uuid: _uuid} ->
                {"#{name}", Commercefacile.Web.Serializers.AdController.Create.Categories.Children.to_list(children, :select)}
        end
        Enum.into(collections, %{}, fn i -> collectable.(i) end)
    end

    defmodule Children do
        use Remodel

        attributes [:key, :value]

        def key(%{name: name}), do: name
        def value(%{uuid: uuid}), do: uuid

        def to_list(collections, :select) do
            Enum.into(collections, [], fn i -> 
                [key: i.name, value: i.uuid]
            end)
        end
    end
end