ads_path = Path.expand "priv/repo/seeds/master/ads.json"
ads_s = File.read! ads_path
ads_c = Poison.Parser.parse! ads_s
ad_ids = Stream.map(ads_c, fn i -> i["id"] end)

user_path = Path.expand "priv/repo/seeds/master/users.json"
user_s = File.read! user_path
# convert
user_c = Poison.Parser.parse! user_s

find_ad_id = fn ad_id -> 
    case Enum.find(ads_c, fn u -> u["id"] == ad_id end) do
        nil -> raise("Ad not found in json data")
        ad -> 
            %{id: id} = Commercefacile.Repo.get_by!(Commercefacile.Ads.Ad, uuid: ad["uuid"])
            id
    end
end

find_user_id = fn user_id -> 
    case Enum.find(user_c, fn u -> u["id"] == user_id end) do
        nil -> raise("User not found in json data")
        user -> 
            %{id: id} = Commercefacile.Repo.get_by!(Commercefacile.Accounts.User, uuid: user["uuid"])
            id
    end
end

path = Path.expand "priv/repo/seeds/master/reported_ads.json"
s = File.read! path
# convert
c = Poison.Parser.parse! s
# map
parse = &(Timex.parse!(&1, "{ISO:Extended}"))
sd =  Stream.filter(c, fn a -> a["ad_id"] in ad_ids end) 
    |> Stream.map(fn a -> %Commercefacile.Ads.Reported{
        ad_id: find_ad_id.(a["ad_id"]),
        user_id: find_user_id.(a["user_id"]),
        inserted_at: parse.(a["created_at"]),
        updated_at: parse.(a["updated_at"])
    } end)
# insert
Enum.each(sd, fn d -> Commercefacile.Repo.insert! d end)