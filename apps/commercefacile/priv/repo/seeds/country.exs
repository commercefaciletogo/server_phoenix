data = [
    %Commercefacile.Locations.Country{id: 1, name: "Togo", uuid: Ksuid.generate(), code: "00228"}
]

Enum.each(data, fn country -> Commercefacile.Repo.insert!(country) end)