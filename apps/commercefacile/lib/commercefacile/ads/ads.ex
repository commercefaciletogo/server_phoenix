defmodule Commercefacile.Ads do
    import Ecto.Query, only: [from: 2]

    alias Commercefacile.Repo
    alias Commercefacile.Ads.{
        Category,
        Ad,
        Images,
        Reported,
        Rejected,
        Favorited
    }

    @default_ads_life [months: 6]

    @generator Application.get_env(:commercefacile, Commercefacile.Services) |> Keyword.get(:generator)

    def new_ad(%Commercefacile.Accounts.Guest.Ad{} = ad, user) do
        ad = Map.from_struct ad
        new_ad(ad, user)
    end
    def new_ad(%{} = ad, %{id: user_id} = _user) do
        changeset = Ad.form_changeset(ad, :private)
        if changeset.valid? do
            %{category: category_uuid, images: images} = changes = changeset.changes
            %{id: category_id} = Repo.get_by(Category, uuid: category_uuid)
            ad_changeset = Ad.changeset(%Ad{}, Map.merge(changes, %{user_id: user_id, category_id: category_id}))
                |> Ad.add_uuid
                |> Ad.add_pending_status

            result = Ecto.Multi.new
                |> Ecto.Multi.insert(:ad, ad_changeset)
                |> Ecto.Multi.run(:hashed_id_ad, fn %{ad: %{id: id} = ad} -> 
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
                {:ok, %{hashed_id_ad: ad}} -> {:ok, Repo.preload(ad, :images)}
                {:error, :ad, changeset, _} -> {:error, changeset}
                {:error, :hash_id, _, _} -> {:error, :internal_error}
                {:error, :images, _, _} -> {:error, :internal_error}
            end
        else
            {:error, :invalid_data, changeset}
        end
    end

    # def get_ad([{:uuid, uuid}]) do
    #     case Repo.get_by(Ad, uuid: uuid) do
    #         %Ad{} = ad -> {:ok, Repo.preload(ad, [:user, :images, :reporters, :favoriters])}
    #         nil -> {:error, :not_found}
    #     end
    # end
    def get_ad([{:uuid, uuid}, {:user, user}]) do
        case Repo.get_by(Ad, uuid: uuid, user_id: user.id) do
            %Ad{status: "pending"} = ad -> {:ok, Repo.preload(ad, [:rejected, :category, :images])}
            %Ad{status: "rejected"} = ad -> {:ok, Repo.preload(ad, [:rejected, :category, :images])}
            _ -> {:error, :not_found}
        end
    end
    def get_ad([{:uuid, uuid}, {:status, status}]) 
    when status in [:online, :offline, :rejected, :pending]
    do
        case Repo.get_by(Ad, uuid: uuid, status: Atom.to_string(status)) |> Repo.preload([:user]) do
            %Ad{} = %{user: user} = ad -> 
                {:ok, 
                    Repo.preload(ad, [:category, :images, :reporters, :favoriters]), 
                    Repo.preload(user, [:location])
                }
            nil -> {:error, :not_found}
        end
    end

    def edit_ad(uuid, %{"images" => _} = data, user) do
        data = for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}
        edit_ad(uuid, data, user)
    end
    def edit_ad(ad_uuid, %{images: _} = data, _user) do
        # validate
        changeset = Ad.form_changeset(data, :private)
        %Ad{} = ad = Repo.get_by(Ad, uuid: ad_uuid)
        if changeset.valid? do
            # save
            %{category: category_uuid, images: images} = changes = changeset.changes
            result = Ecto.Multi.new
                |> Ecto.Multi.run(:ad, fn _ -> 
                    %{id: category_id} = Repo.get_by(Category, uuid: category_uuid)
                    changes = Map.merge(Map.drop(changes, [:images, :category]), %{status: "pending", category_id: category_id})
                    Repo.preload(ad, [:images])
                    |> Ad.changeset(changes)
                    |> Ad.add_pending_status
                    |> Repo.update
                end)
                |> Ecto.Multi.run(:images, fn %{ad: ad} -> 
                    from(i in Images, where: i.ad_id == ^ad.id) |> Repo.delete_all
                    images = Stream.with_index(images)
                        |> Stream.map(fn {path, index} -> 
                            index = index + 1
                            {:ok, _, image} = Commercefacile.Image.new!(:original, path, index, scope: ad)
                            image
                        end)
                        |> Stream.map(fn image -> 
                            {:ok, image} = Commercefacile.Image.store(:cloud, image)
                            image
                        end)
                        |> Enum.map(fn %{filename: name, public_url: path, main: main?, version: size} -> 
                            params = %{name: name, path: path, main: main?, size: Atom.to_string(size), ad_id: ad.id}
                            {:ok, image} = Repo.insert(Images.changeset(%Images{}, params))
                            image
                        end)
                    {:ok, images}
                end)
                |> Repo.transaction
            case result do
                {:ok, %{ad: ad}} -> {:ok, Repo.get(Commercefacile.Ads.Ad, ad.id) |> Repo.preload([:images])}
                {:error, :ad, changeset, _} -> {:error, changeset}
                {:error, :images, changeset, _} -> {:error, changeset}
            end
        else
            {:error, :invalid_data, changeset}
        end
    end

    def update_ad(uuid, fields) do
        Repo.get_by(Commercefacile.Ads.Ad, uuid: uuid)
        |> Commercefacile.Ads.Ad.changeset(fields)
        |> Repo.update
    end

    def review_ad(uuid) do
        start_date = Timex.now
        end_date = Timex.shift(start_date, @default_ads_life)
        # change ad status to online
        {:ok, ad} = update_ad(uuid, %{
            status: "online", start_date: start_date, end_date: end_date})
        %{images: images} = ad = Repo.preload(ad, [:images])
        # generate small and big images
        smalls = Stream.map(images, fn %{path: url} ->  
            %{path: path} = URI.parse(url)
            [_|[index|[_]]] = String.split(path, "_")
            {:ok, _, image} = Commercefacile.Image.new!(:small, url, String.to_integer(index), scope: ad)
            image
        end)
        bigs = Stream.map(images, fn %{path: url} ->  
            %{path: path} = URI.parse(url)
            [_|[index|[_]]] = String.split(path, "_")
            {:ok, _, image} = Commercefacile.Image.new!(:big, url, String.to_integer(index), scope: ad)
            image
        end)
        Stream.concat(smalls, bigs)
        |> Stream.map(fn image ->  
            {:ok, image} = Commercefacile.Image.watermark(image, Commercefacile.Image.get_watermark_path())
            image
        end)
        |> Stream.map(fn image -> 
            {:ok, image} = Commercefacile.Image.store(:cloud, image)
            image
        end)
        |> Enum.map(fn %{filename: name, public_url: path, main: main?, version: size} -> 
            params = %{name: name, path: path, main: main?, size: Atom.to_string(size), ad_id: ad.id}
            {:ok, image} = Repo.insert(Images.changeset(%Images{}, params))
            image
        end)
        {:ok, Repo.get(Ad, ad.id) |> Repo.preload([:images])}
    end
    def review_ad(uuid, rejected_fields) do
        with %Ad{id: ad_id} <- Repo.get_by(Ad, uuid: uuid),
            nil <- Repo.get_by(Rejected, ad_id: ad_id)
        do
            {:ok, %{status: "rejected"} = ad} = update_ad(uuid, %{status: "rejected"})
            %Rejected{}
            |> Rejected.changeset(Map.merge(%{ad_id: ad_id}, rejected_fields))
            |> Repo.insert
            {:ok, Repo.preload(ad, [:rejected])}
        else
            nil -> {:error, :not_found}
            %Rejected{} = old ->
                Rejected.changeset(old, rejected_fields)
                |> Repo.update
        end
        # change ad status to rejected
        update_ad(uuid, %{status: "rejected"})
    end

    def off_ad(uuid) do
        update_ad(uuid, %{status: "offline"})
    end

    def report_ad(uuid, user) do
        with %Ad{id: ad_id} = ad <- Repo.get_by(Ad, uuid: uuid),
            nil <- Repo.get_by(Reported, ad_id: ad_id, user_id: user.id)
        do
            data = %{user_id: user.id, ad_id: ad_id}
            %Reported{}
            |> Reported.changeset(data)
            |> Repo.insert
            {:ok, Repo.preload(ad, [:reporters])}
        else
            nil -> {:error, :not_found}
            %Reported{} = reported -> {:ok, reported}
        end
    end

    def unreport_ad(uuid, user) do
        with %Ad{id: ad_id} = ad <- Repo.get_by(Ad, uuid: uuid),
            %Reported{} = reporter <- Repo.get_by(Reported, ad_id: ad_id, user_id: user.id)
        do
            Repo.delete(reporter)
            {:ok, Repo.preload(ad, [:reporters])}
        else
            nil -> {:error, :not_found}
        end
    end

    def favorite_ad(uuid, user) do
        with %Ad{id: ad_id} = ad <- Repo.get_by(Ad, uuid: uuid),
            nil <- Repo.get_by(Favorited, ad_id: ad_id, user_id: user.id)
        do
            data = %{user_id: user.id, ad_id: ad_id}
            %Favorited{}
            |> Favorited.changeset(data)
            |> Repo.insert
            {:ok, Repo.preload(ad, [:favoriters])}
        else
            nil -> {:error, :not_found}
            %Favorited{} = favorited -> {:ok, favorited}
        end
    end

    def unfavorite_ad(uuid, user) do
        with %Ad{id: ad_id} = ad <- Repo.get_by(Ad, uuid: uuid),
            %Favorited{} = favoriter <- Repo.get_by(Favorited, ad_id: ad_id, user_id: user.id)
        do
            Repo.delete(favoriter)
            {:ok, Repo.preload(ad, [:favoriters])}
        else
            nil -> {:error, :not_found}
        end
    end

    def delete_ad([{:uuid, uuid}, {:user, owner}]) do
        case Repo.get_by(Ad, uuid: uuid, user_id: owner.id) do
            nil -> {:error, :not_found}
            ad -> Repo.delete(ad)
        end
    end
    def delete_ad(uuid) do
        Repo.get_by(Ad, uuid: uuid)
        |> Repo.delete
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