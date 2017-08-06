defmodule Commercefacile.Web.Serializers.AdController.Index.Ad do
    use Remodel

    @locale Gettext.get_locale(Commercefacile.Web.Gettext)

    attributes [:uuid, :thumbnail, :title, :category, :price, :date]

    def thumbnail(%{images: images}) do
        result = Enum.filter(images, fn %{size: size, main: main} ->  
            size == "small" && main
        end)
        case result do
            [] -> ""
            [%{path: path} | _] -> path
        end
    end

    def date(%{start_date: date, inserted_at: in_date}) do
        date = unless is_nil(date), do: date, else: in_date
        {:ok, string} = Timex.lformat(date, "{relative}", @locale, :relative)
        string
    end

    def category(%{category: %{name: name}}) do
        name
    end

    # def price(%{price: price}) do
    #     String.to_integer(price)
    #     |> Commercefacile.Web.Helpers.Number.number_with_delimiter
    # end

end