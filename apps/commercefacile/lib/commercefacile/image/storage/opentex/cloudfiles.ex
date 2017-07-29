defmodule Commercefacile.Image.Storage.Opentex.Cloudfiles do
    @moduledoc :false
    use Openstex.Client, otp_app: :commercefacile, client: __MODULE__

    defmodule Swift do
        @moduledoc :false
        use Openstex.Swift.V1.Helpers, otp_app: :commercefacile, client: Commercefacile.Image.Storage.Opentex.Cloudfiles
    end
end