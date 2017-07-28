defmodule Commercefacile.Web.Serializers.AdController.Index.Categories do
    use Remodel

    attribute :uuid
    attribute :name
    attribute :subs

    def subs(%{uuid: uuid, name: name, children: []}) do
        [%{uuid: uuid, name: name}]
    end
    def subs(%{children: children}) do
        Enum.map(children, fn cat -> 
            %{uuid: cat.uuid, name: cat.name} 
        end)
    end
end