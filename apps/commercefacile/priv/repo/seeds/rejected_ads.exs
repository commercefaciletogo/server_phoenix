ads_path = Path.expand "priv/repo/seeds/master/ads.json"
ads_s = File.read! ads_path
ads_c = Poison.Parser.parse! ads_s
ad_ids = Stream.map(ads_c, fn i -> i["id"] end)

path = Path.expand "priv/repo/seeds/master/rejected_ads.json"
s = File.read! path
# convert
c = Poison.Parser.parse! s
# map
parse = &(Timex.parse!(&1, "{ISO:Extended}"))
sd = Stream.filter(c, fn a -> a["ad_id"] in ad_ids end) 
    |> Stream.map(fn a -> %Commercefacile.Ads.Rejected{
        id: a["id"],
        fields: a["fields"],
        ad_id: a["ad_id"],
        inserted_at: parse.(a["created_at"]),
        updated_at: parse.(a["updated_at"])
    } end)
# insert
Enum.each(sd, fn d -> Commercefacile.Repo.insert! d end)