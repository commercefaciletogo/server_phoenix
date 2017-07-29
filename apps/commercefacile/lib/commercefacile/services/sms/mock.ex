defmodule Commercefacile.Services.SMS.Mock do
    @behaviour Commercefacile.Services.SMS.Behaviour

    def text(originator, recipient, message) do
        {:ok, %{}}
    end
    
end