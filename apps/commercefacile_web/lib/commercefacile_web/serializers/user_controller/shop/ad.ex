defmodule Commercefacile.Web.Serializers.UserController.Shop.Ad do
    use Remodel

    @locale Gettext.get_locale(Commercefacile.Web.Gettext)

    attributes [:uuid, :thumbnail, :title, :category, :price, :date]

    def thumbnail(%{images: images}) do
        result = Enum.filter(images, fn %{size: size, main: main} ->  
            size == "small" && main
        end)
        case result do
            [] -> ""
            images -> 
                %{path: path} = List.first(images)
                path
        end
    end

    def date(%{start_date: date}) do
        {:ok, string} = Timex.lformat(date, "{relative}", @locale, :relative)
        string
    end

    def category(%{category: %{name: name}}) do
        name
    end

    def price(%{price: price}) do
        Commercefacile.Web.Helpers.Number.number_with_delimiter(price)
    end

end