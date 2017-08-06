defmodule Commercefacile.Accounts.Verification.Code do
    use Ecto.Schema
    import Ecto.Changeset

    alias Commercefacile.Accounts.Verification.Code

    schema "verification_codes" do
        field :code, :string
        field :reference, :string

        belongs_to :user, Commercefacile.Accounts.User, type: :string

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:code, :user_id])
        |> validate_required([:code, :user_id])
        |> validate_length(:code, is: 6)
        |> add_reference
    end

    def new(), do: changeset(%Code{})

    defp add_reference(changeset), do: put_change(changeset, :reference, Ksuid.generate())
end