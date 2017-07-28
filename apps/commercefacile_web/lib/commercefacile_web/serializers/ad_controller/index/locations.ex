defmodule Commercefacile.Web.Serializers.AdController.Index.Locations do
    use Remodel

    attributes [:uuid, :name, :subs]

    def subs(%{uuid: uuid, name: name, children: []}) do
        [%{uuid: uuid, name: name}]
    end
    def subs(%{children: children}) do
        Enum.map(children, fn loc -> %{
            uuid: loc.uuid,
            name: loc.name
        } end)
    end
end