defmodule Commercefacile.Web.Serializers.AdController.Show.Author do
    use Remodel

    attributes [:uuid, :name, :location, :phone]

    def name(%{name: name}) do
        String.capitalize(name)
    end

    def location(%{location: nil}) do
        "N/A"
    end
    def location(%{location: %{uuid: uuid, name: name}}) do
        %{
            uuid: uuid,
            name: name
        }
    end
end