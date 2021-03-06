defmodule Commercefacile.Web.Serializers.AdController.Show.Ad do
    use Remodel

    @locale Gettext.get_locale(Commercefacile.Web.Gettext)

    attributes [:uuid, :price, :negotiable, :title, :category, :pictures, :thumbnails, :description, :condition, :reported, :favorited, :date_of_post]

    def price(%{price: price}) do
        Commercefacile.Web.Helpers.Number.number_with_delimiter(price)
    end
    
    def category(%{category: %{name: name, uuid: uuid}}) do
        %{name: name, uuid: uuid}
    end
    
    def pictures(%{images: images}) do
        Stream.filter(images, fn image -> image.size == "big" end)
        |> Stream.map(fn image -> 
            %{
                path: image.path,
                main: image.main
            } 
        end)
        |> Enum.sort_by(fn %{main: main} -> !main end)
    end

    def thumbnails(%{images: images}) do
        Stream.filter(images, fn image -> image.size == "small" end)
        |> Stream.map(fn image -> 
            %{
                path: image.path,
                main: image.main
            } 
        end)
        |> Enum.sort_by(fn %{main: main} -> !main end)
    end

    def condition(%{condition: condition}) do
        Gettext.gettext(Commercefacile.Web.Gettext, condition)
    end

    def reported(%{reporters: _}, nil), do: false
    def reported(%{reporters: reporters}, %{id: id}) do
        Enum.any?(reporters, fn %{id: r_id} -> r_id == id end)
    end

    def favorited(%{favoriters: _}, nil), do: false
    def favorited(%{favoriters: favoriters}, %{id: id}) do
        Enum.any?(favoriters, fn %{id: f_id} -> f_id == id end)
    end

    def date_of_post(%{start_date: date, inserted_at: in_date}) do
        date = unless is_nil(date), do: date, else: in_date
        {:ok, string} = Timex.lformat(date, "{relative}", @locale, :relative)
        string
    end
end