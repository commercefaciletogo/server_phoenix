defmodule Commercefacile.Accounts.Guest do
    alias Commercefacile.Accounts.Guest

    defstruct [info: %Guest.Information{}, ad: %Guest.Ad{}]
end