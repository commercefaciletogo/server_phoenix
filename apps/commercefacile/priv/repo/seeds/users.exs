path = Path.expand "priv/repo/seeds/master/users.json"
s = File.read! path
# convert
c = Poison.Parser.parse! s
# map
location_id = fn 
    78 -> 22
    86 -> 79
    id when id in 19..20 -> 18
    id when id in 29..32 -> 28
    id when id in 61..70 -> 71
    id -> id
end
parse = &(Timex.parse!(&1, "{ISO:Extended}"))
sd = Stream.map(c, fn a -> %Commercefacile.Accounts.User{
    uuid: a["uuid"],
    name: a["name"],
    verified: true,
    email: a["email"],
    phone: "00228" <> a["phone"],
    active: a["status"] == "active",
    password: a["password"],
    location_id: location_id.(a["location_id"]),
    inserted_at: parse.(a["created_at"]),
    updated_at: parse.(a["updated_at"])
} end)
# insert
Enum.each(sd, fn d -> Commercefacile.Repo.insert!(d) end)