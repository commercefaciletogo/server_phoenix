defmodule Commercefacile.Services.SMS.Behaviour do
    @callback text(originator :: String.t, recipient :: String.t, message :: String.t) :: {:ok, %{}} | {:error, term} 
end