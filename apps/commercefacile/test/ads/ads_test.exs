defmodule Commercefacile.AdsTest do
    use Commercefacile.DataCase

    # @tag :skip
    test "new ad" do
        payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
        assert {:ok, user, _} = Commercefacile.Accounts.new_user(payload)
        category = %{name: "category", uuid: "uuid", inserted_at: Timex.today() |> Timex.to_datetime, updated_at: Timex.today() |> Timex.to_datetime}
        {1, [%{uuid: category}]} = Commercefacile.Repo.insert_all(Commercefacile.Ads.Category, [category], returning: true)
        ad = %{title: "title of ad", condition: "new", description: "jflad,f akdfjal,f adkfjald,f akdfjald", price: "200", negotiable: true, category: category, images: ["https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"]}
        
        
        assert {:ok, %Commercefacile.Ads.Ad{status: "pending", images: [image]}} = Commercefacile.Ads.new_ad(ad, user)
        assert %{main: true} = image
    end
end