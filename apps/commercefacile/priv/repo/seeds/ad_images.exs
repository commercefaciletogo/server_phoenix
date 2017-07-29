path = Path.expand "priv/repo/seeds/master/ad_images.json"
ads_path = Path.expand "priv/repo/seeds/master/ads.json"
s = File.read! path
ads_s = File.read! ads_path
# convert
c = Poison.Parser.parse! s
ads_c = Poison.Parser.parse! ads_s
# map
ad_ids = Stream.map(ads_c, fn i -> i["id"] end)

parse = &(Timex.parse!(&1, "{ISO:Extended}"))

sd = Stream.filter(c, fn a -> a["ad_id"] in ad_ids end) 
    |> Stream.map(fn a -> %Commercefacile.Ads.Images{
        id: a["id"],
        ad_id: a["ad_id"],
        path: a["path"],
        name: a["name"],
        main: a["main"],
        size: a["size"],
        inserted_at: parse.(a["created_at"]),
        updated_at: parse.(a["updated_at"])
    } end)
# insert
Enum.each(sd, fn d -> Commercefacile.Repo.insert!(d) end)