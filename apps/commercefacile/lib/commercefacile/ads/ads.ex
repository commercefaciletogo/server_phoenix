defmodule Commercefacile.Ads do
    import Ecto.Query, only: [from: 2]

    alias Commercefacile.Repo
    alias Commercefacile.Ads.{
        Category,
        Ad,
        Images
    }

    @generator Application.get_env(:commercefacile, Commercefacile.Services) |> Keyword.get(:generator)

    def new_ad(%{} = ad, %{id: user_id}) do
        changeset = Ad.form_changeset(ad, :private)
        if changeset.valid? do
            %{category: category_uuid, images: images} = changes = changeset.changes
            %{id: category_id} = Repo.get_by(Category, uuid: category_uuid)
            ad_changeset = Ad.changeset(%Ad{}, Map.merge(changes, %{user_id: user_id, category_id: category_id}))
            result = Ecto.Multi.new
                |> Ecto.Multi.insert(:ad, ad_changeset)
                |> Ecto.Multi.run(:hash_id, fn %{ad: %{id: id} = ad} -> 
                    code = @generator.generate_hashid(id)
                    Repo.update(Ecto.Changeset.change(ad, code: code))
                end)
                |> Ecto.Multi.run(:images, fn %{ad: %{id: ad_id} = scope} ->  
                    images = Stream.with_index(images)
                        |> Stream.map(fn {path, index} -> 
                            index = index + 1
                            {:ok, _, image} = Commercefacile.Image.new!(:original, path, index, scope: scope)
                            image
                        end)
                        |> Stream.map(fn image -> 
                            {:ok, image} = Commercefacile.Image.store(:cloud, image)
                            image
                        end)
                        |> Enum.map(fn %{filename: name, public_url: path, main: main?, version: size} -> 
                            params = %{name: name, path: path, main: main?, size: Atom.to_string(size), ad_id: ad_id}
                            {:ok, image} = Repo.insert(Images.changeset(%Images{}, params))
                            image
                        end)
                    {:ok, images}
                end)
                |> Repo.transaction

            case result do
                {:ok, %{ad: ad}} -> {:ok, Repo.preload(ad, :images)}
                {:error, :ad, changeset, _} -> {:error, changeset}
                {:error, :hash_id, _, _} -> {:error, :internal_error}
                {:error, :images, _, _} -> {:error, :internal_error}
            end
        else
            {:error, :invalid_data, changeset}
        end
    end

    def get_categories(:main) do
        q = from c in Category,
            where: is_nil(c.parent_id),
            where: not is_nil(c.icon)

        Repo.all(q)
    end
    def get_categories(:main_with_children) do
        q = from c in Category,
            where: is_nil(c.parent_id),
            where: not is_nil(c.icon),
            preload: [:children]

        Repo.all(q)
    end
    def get_categories(:all) do
        Repo.all(Category)
    end
end