user_path = Path.expand "priv/repo/seeds/master/users.json"
user_s = File.read! user_path
# convert
user_c = Poison.Parser.parse! user_s

find_user_id = fn user_id -> 
    case Enum.find(user_c, fn u -> u["id"] == user_id end) do
        nil -> raise("User not found in json data")
        user -> 
            %{id: id} = Commercefacile.Repo.get_by!(Commercefacile.Accounts.User, uuid: user["uuid"])
            id
    end
end

path = Path.expand "priv/repo/seeds/master/ads.json"
s = File.read! path
# convert
c = Poison.Parser.parse! s
# map
parse = fn
    nil -> nil 
    time -> Timex.parse!(time, "{ISO:Extended}")
end

sd = Stream.map(c, fn a -> %Commercefacile.Ads.Ad{
    uuid: a["uuid"],
    code: Commercefacile.Services.Generator.generate_hashid(a["id"]),
    title: a["title"],
    condition: a["condition"],
    description: a["description"],
    price: a["price"],
    negotiable: a["negotiable"],
    category_id: a["category_id"],
    user_id: find_user_id.(a["user_id"]),
    status: a["status"],
    end_date: parse.(a["end_date"]),
    start_date: parse.(a["start_date"]),
    inserted_at: parse.(a["created_at"]),
    updated_at: parse.(a["updated_at"])
} end)
# insert
Enum.each(sd, fn d -> Commercefacile.Repo.insert!(d) end)