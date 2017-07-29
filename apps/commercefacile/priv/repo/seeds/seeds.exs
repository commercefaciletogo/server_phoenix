# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
Code.require_file("country.exs", "priv/repo/seeds")
Code.require_file("location.exs", "priv/repo/seeds")
Code.require_file("category.exs", "priv/repo/seeds")
Code.require_file("users.exs", "priv/repo/seeds")
Code.require_file("ads.exs", "priv/repo/seeds")
Code.require_file("ad_images.exs", "priv/repo/seeds")
Code.require_file("favorited_ads.exs", "priv/repo/seeds")
Code.require_file("rejected_ads.exs", "priv/repo/seeds")
# Code.require_file("reported_ads.exs", "priv/repo/seeds")

#
#     Commercefacile.Repo.insert!(%Commercefacile.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
