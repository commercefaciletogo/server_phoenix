defmodule Commercefacile.AccountsTest do
    use Commercefacile.DataCase

    test "new_user" do
        payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
        assert {:ok, %{phone: "002289110735"}, _} = Commercefacile.Accounts.new_user(payload)
    end

    describe "phone_taken?" do
        test "false" do
            refute Commercefacile.Accounts.phone_taken?("+2289110735")
        end
        
        test "{true, :unverified_user}" do
            payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
            assert {:ok, _, _} = Commercefacile.Accounts.new_user(payload)
            assert {true, :unverified_user} = Commercefacile.Accounts.phone_taken?("+2289110735")
        end
    end

    describe "verify phone" do
        test "{:error, :not_found}" do
            assert {:error, :not_found} = Commercefacile.Accounts.verify_phone(%{phone: "+2289110735"})
        end
        test "{:ok, user, code}" do
            payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
            assert {:ok, _, _} = Commercefacile.Accounts.new_user(payload)
            assert {:ok, _, _} = Commercefacile.Accounts.verify_phone(%{phone: "+2289110735"})
        end
    end

    test "verify code" do
        payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
        assert {:ok, _, %{code: code, reference: reference}} = Commercefacile.Accounts.new_user(payload)
        code_changeset = %{code: code}
        assert {:ok, %Commercefacile.Accounts.User{verified: true, active: true}} = Commercefacile.Accounts.verify_code(%{code_changeset: code_changeset, reference: reference})
    end

    describe "find_and_confirm_password" do
        test "{:error, :not_found, changeset}" do
            assert {:error, :not_found, _} = Commercefacile.Accounts.find_and_confirm_password(%{phone: "+2289110735", password: "secret"})
        end
        test "{:error, :no_match, changeset}" do
            payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
            assert {:ok, _, %{code: code, reference: reference}} = Commercefacile.Accounts.new_user(payload)
            code_changeset = %{code: code}
            assert {:ok, %Commercefacile.Accounts.User{verified: true, active: true}} = Commercefacile.Accounts.verify_code(%{code_changeset: code_changeset, reference: reference})
            assert {:error, :no_match, _} = Commercefacile.Accounts.find_and_confirm_password(%{phone: "+2289110735", password: "secret"})
        end
        test "{:ok, user}" do
            payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
            assert {:ok, _, %{code: code, reference: reference}} = Commercefacile.Accounts.new_user(payload)
            code_changeset = %{code: code}
            assert {:ok, %Commercefacile.Accounts.User{verified: true, active: true}} = Commercefacile.Accounts.verify_code(%{code_changeset: code_changeset, reference: reference})
            assert {:ok, _} = Commercefacile.Accounts.find_and_confirm_password(%{phone: "+2289110735", password: "secretpass"})
        end
    end

    describe "reset_user_password" do
        test "{:ok, user}" do
            payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
            assert {:ok, _, %{code: code, reference: reference}} = Commercefacile.Accounts.new_user(payload)
            code_changeset = %{code: code}
            assert {:ok, %Commercefacile.Accounts.User{verified: true, active: true} = user} = Commercefacile.Accounts.verify_code(%{code_changeset: code_changeset, reference: reference})
            assert {:ok, _} = Commercefacile.Accounts.reset_user_password(%{reset: %{password: "secretpass_strong", password_confirmation: "secretpass_strong"}, user: user})
            assert {:ok, _} = Commercefacile.Accounts.find_and_confirm_password(%{phone: "+2289110735", password: "secretpass_strong"})
        end
    end

    describe "change_user_password" do
        test "{:ok, user}" do
            payload = %{name: "pinana Pijo", phone: "+2289110735", password: "secretpass", password_confirmation: "secretpass", terms: true}
            assert {:ok, _, %{code: code, reference: reference}} = Commercefacile.Accounts.new_user(payload)
            code_changeset = %{code: code}
            assert {:ok, %Commercefacile.Accounts.User{verified: true, active: true} = user} = Commercefacile.Accounts.verify_code(%{code_changeset: code_changeset, reference: reference})
            assert {:ok, _} = Commercefacile.Accounts.change_user_password(%{reset: %{old_password: "secretpass", password: "secretpass_strong", password_confirmation: "secretpass_strong"}, user: user})
            assert {:ok, _} = Commercefacile.Accounts.find_and_confirm_password(%{phone: "+2289110735", password: "secretpass_strong"})
        end
    end
end