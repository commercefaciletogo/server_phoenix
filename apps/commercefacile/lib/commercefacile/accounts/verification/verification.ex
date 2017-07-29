defmodule Commercefacile.Accounts.Verification do
    alias Commercefacile.Accounts
    alias Commercefacile.Repo

    @generator Application.get_env(:commercefacile, Commercefacile.Services) |> Keyword.get(:generator)

    def generate_code_for(%Accounts.User{id: id}) do
        code = @generator.generate_digits(6)
        changeset = Accounts.Verification.Code
                        .changeset(%Accounts.Verification.Code{}, %{code: code, expired: false, user_id: id})
        Repo.insert changeset
    end

    def code_sms_template(code) do
        "#{code} est votre code de verification."
    end

    def validate(%{code: code, reference: reference}) do
        with %Accounts.Verification.Code{} = r_code <- Repo.get_by(Accounts.Verification.Code, reference: reference),
            true <- r_code.code == code,
            {:ok, _} <- Repo.delete(r_code)
        do
            {:ok, Repo.preload(r_code, :user)}
        else
            nil -> {:error, :invalid_data}
            false -> {:error, :invalid_data}            
        end
    end
end