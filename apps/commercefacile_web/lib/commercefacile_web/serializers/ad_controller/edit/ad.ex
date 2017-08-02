defmodule Commercefacile.Web.Serializers.AdController.Edit.Ad do
    use Remodel

    attributes [:uuid, :title, :category, :condition, :description, :price, :negotiable, :rejecteds, :images]

    def category(%{category: %{uuid: uuid}}), do: uuid

    def images(%{images: images}) do
        Stream.filter(images, fn image -> image.size == "original" end)
        |> Enum.map(fn %{path: path} -> path end)
    end

    def rejecteds(%{rejected: nil}), do: {nil, nil}
    def rejecteds(%{rejected: fields}) do
        locales = String.split(fields)
        |> Enum.map(fn field ->  
            Gettext.gettext(Commercefacile.Web.Gettext, field)
        end)
        {Enum.map(fields, fn f -> String.to_atom(f) end), locales}
    end
end