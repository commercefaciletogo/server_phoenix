defmodule Commercefacile.Web.Serializers.UserController.Dashboard.Ad do
    use Remodel

    attributes [:title, :status, :category, :price, :tr_status, :picture, :rejecteds]

    def category(%{category: %{name: name}}), do: name

    def tr_status(%{status: status}), do: Gettext.gettext(Commercefacile.Web.Gettext, status)

    def picture(%{images: images}) do
        image = Stream.filter(images, fn image -> image.size == "original" end)
            |> Stream.map(fn image -> 
                %{
                    path: image.path,
                    main: image.main
                } 
            end)
            |> Enum.sort_by(fn %{main: main} -> !main end) 
            |> List.first
        if image, do: image.path, else: ""
    end

    def rejecteds(%{rejected: nil}), do: nil
    def rejecteds(%{rejected: fields}) do
        locales = String.split(fields)
        |> Enum.map(fn field ->  
            Gettext.gettext(Commercefacile.Web.Gettext, field)
        end)
    end

    def price(%{price: price}) do
        Commercefacile.Web.Helpers.Number.number_with_delimiter(price)
    end
end