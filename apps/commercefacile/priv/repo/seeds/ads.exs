path = Path.expand "priv/repo/seeds/master/ads.json"
s = File.read! path
# convert
c = Poison.Parser.parse! s
# map
parse = fn
    nil -> nil 
    time -> Timex.parse!(time, "{ISO:Extended}")
end
h = Hashids.new([min_len: 7, salt: "XPEoIo/y8r5Tw2tcWqse6Fed2oDpWUGqo+IDd7L/WcDjWdXUN01f9mu/He476IIv"])
sd = Stream.map(c, fn a -> %Commercefacile.Ads.Ad{
    id: a["id"],
    uuid: a["uuid"],
    code: Commercefacile.Services.Generator.generate_hashid(ad["id"]),
    title: a["title"],
    condition: a["condition"],
    description: a["description"],
    price: Integer.to_string(a["price"]),
    negotiable: a["negotiable"],
    category_id: a["category_id"],
    user_id: a["user_id"],
    status: a["status"],
    end_date: parse.(a["end_date"]),
    start_date: parse.(a["start_date"]),
    inserted_at: parse.(a["created_at"]),
    updated_at: parse.(a["updated_at"])
} end)
# insert
Enum.each(sd, fn d -> Commercefacile.Repo.insert!(d) end)