defmodule Commercefacile.Services.SMS do
    @behaviour Commercefacile.Services.SMS.Behaviour

    def text(orignator, recipient, message) do
        # send message using third party lib
        {:ok, %{orignator: orignator, recipient: recipient, message: message}}
    end
end