defmodule Commercefacile.AdsTest do
    use Commercefacile.DataCase

    setup do
        payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
        {:ok, user, _} = Commercefacile.Accounts.new_user(payload)

        date = Timex.today() |> Timex.to_datetime

        category = %{name: "category", uuid: "uuid", inserted_at: date, updated_at: date}
        {1, [category]} = Commercefacile.Repo.insert_all(Commercefacile.Ads.Category, [category], returning: true)

        country = %{name: "country", uuid: "uuid", inserted_at: date, updated_at: date}
        {1, [%{id: country_id}]} = Commercefacile.Repo.insert_all(Commercefacile.Locations.Country, [country], returning: true)

        location = %{name: "location", country_id: country_id, uuid: "uuid", inserted_at: date, updated_at: date}
        {1, [location]} = Commercefacile.Repo.insert_all(Commercefacile.Locations.Location, [location], returning: true)

        [user: user, category: category, location: location, date: date]
    end

    # @tag :skip
    test "new ad", %{user: user, category: category} do
        ad = %{title: "title of ad", condition: "new", 
            description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", 
            negotiable: true, category: category.uuid,
            images: [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg",
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"]
            }
        
        assert {:ok, %Commercefacile.Ads.Ad{code: code, status: "pending", images: images}} = Commercefacile.Ads.new_ad(ad, user)
        assert Enum.any?(images, fn %{main: main?} -> main? end)
        refute is_nil(code)

        Enum.each(images, fn %{path: path} -> Commercefacile.Image.delete(:cloud, path) end)
    end

    setup %{user: user, category: category, date: date} do
        ad = %{title: "title of ad", condition: "new", 
            description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", 
            negotiable: true, category: category.uuid, 
            images: [
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6fEaQR0nVJXJwgIadfLl05XlS_original.jpeg",
                "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"]
            }
        {:ok, ad} = Commercefacile.Ads.new_ad(ad, user)

        [ad: ad]
    end

    describe "list ad with" do
        # @tag :skip 
        test "no params" do
            assert %{} = Commercefacile.Ads.list
        end
        # @tag :skip 
        test "category" do
            assert %{} = Commercefacile.Ads.list(%{"c" => "jfkasdlfjajf"})
        end
        # @tag :skip 
        test "location" do
            assert %{} = Commercefacile.Ads.list(%{"l" => "jfkasdlfjajf"})
        end
        # @tag :skip 
        test "location and category" do
            assert %{} = Commercefacile.Ads.list(%{"c" => "jfkasdlfjajf", "l" => "jfkasdlfjajf"})
        end
        # @tag :skip 
        test "current page -> 4" do
            assert %{} = Commercefacile.Ads.list(%{"c" => "jfkasdlfjajf", "l" => "jfkasdlfjajf", "p" => 4})
        end
         # @tag :skip 
        test "sort" do
            assert %{} = Commercefacile.Ads.list(%{"s" => "d|desc"})
            assert %{} = Commercefacile.Ads.list(%{"s" => "p|desc"})
        end
        test "resilience" do
            assert %{} = Commercefacile.Ads.list(%{"s" => "d|df", "error" => 2})
        end
    end
    
    describe "edit ad" do

        # @tag :skip
        test "ad details", %{user: user, ad: ad, category: category} do
            %{uuid: uuid, images: [%{path: f_path} | [%{path: s_path}]]} = ad
            %{title: title, price: price} = fields = %{title: "new ad title", price: "3000", 
                description: ad.description,
                negotiable: ad.negotiable,
                category: category.uuid,
                condition: ad.condition,
                images: [
                    f_path,
                    s_path,
                    "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"
                ]}

            assert {:ok, %{uuid: ^uuid, status: "pending", title: ^title, price: 3000, images: images}} = 
                Commercefacile.Ads.edit_ad(ad.uuid, fields, user)
            assert length(images) == 3
            assert Enum.any?(images, fn %{main: main?} -> main? end)


            Enum.each(images, fn %{path: path} -> Commercefacile.Image.delete(:cloud, path) end)
        end
    end

    
    describe "review ad" do
        # @tag :skip
        test "success", %{ad: ad} do
            %{uuid: uuid, code: code} = ad
            assert {:ok, %{uuid: ^uuid, code: ^code, status: "online", images: images}} = Commercefacile.Ads.review_ad(ad.uuid)
            assert length(images) == 6
        end
        # @tag :skip
        test "rejected", %{ad: ad} do
            rejected_fields = %{fields: "title, price, images"}
            assert {:ok, %{status: "rejected"}} = Commercefacile.Ads.review_ad(ad.uuid, rejected_fields)
        end
    end

    
    describe "update ad" do
        # @tag :skip
        test "status offline", %{ad: ad} do
            fields = %{status: "offline"}
            assert {:ok, %{status: "offline"}} = Commercefacile.Ads.update_ad(ad.uuid, fields)
        end
        # @tag :skip
        test "status online", %{ad: ad} do
            fields = %{status: "online"}
            assert {:ok, %{status: "online"}} = Commercefacile.Ads.update_ad(ad.uuid, fields)
        end
    end

    # @tag :skip
    test "report ad", %{user: user, ad: ad} do
        assert {:ok, %{reporters: [_|[]]}} = Commercefacile.Ads.report_ad(ad.uuid, user)
        assert {:ok, %{reporters: []}} = Commercefacile.Ads.unreport_ad(ad.uuid, user)
    end
    test "can report ad only once", %{user: user, ad: ad} do
        assert {:ok, %{id: ad_id, user_id: user_id, reporters: [_|[]]}} = Commercefacile.Ads.report_ad(ad.uuid, user)
        assert {:ok, %Commercefacile.Ads.Reported{user_id: ^user_id, ad_id: ^ad_id}} = Commercefacile.Ads.report_ad(ad.uuid, user)
    end

    # @tag :skip
    test "favorite ad", %{user: user, ad: ad} do
        assert {:ok, %{favoriters: [_|[]]}} = Commercefacile.Ads.favorite_ad(ad.uuid, user)
        assert {:ok, %{favoriters: []}} = Commercefacile.Ads.unfavorite_ad(ad.uuid, user)
    end
    test "can favorite ad only once", %{user: user, ad: ad} do
        assert {:ok, %{favoriters: [_|[]]}} = Commercefacile.Ads.favorite_ad(ad.uuid, user)
        assert {:ok, %Commercefacile.Ads.Favorited{}} = Commercefacile.Ads.favorite_ad(ad.uuid, user)
    end

    # @tag :skip
    test "delete ad", %{user: user, ad: ad} do
        assert {:ok, %{}} = Commercefacile.Ads.delete_ad(ad.uuid)
    end
end