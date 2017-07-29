defmodule Commercefacile.Image.Storage.Opentex.CloudfilesCDN do
    @moduledoc :false
    use Openstex.Client, otp_app: :commercefacile, client: __MODULE__

    defmodule Swift do
        @moduledoc :false
        use Openstex.Swift.V1.Helpers, otp_app: :commercefacile, client: Commercefacile.Image.Storage.Opentex.CloudfilesCDN
    end
end