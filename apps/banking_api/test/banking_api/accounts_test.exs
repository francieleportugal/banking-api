defmodule BankingApi.AccountsTest do
  use BankingApi.DataCase

  alias BankingApi.Accounts
  alias BankingApi.Accounts.Schemas.User

  describe "create/1" do
    test "create a account with valid data" do
      attrs = %{
        name: "João das Neves",
        email: "joao@email.com.br"
      }

      assert {:ok, user}= Accounts.create(attrs)

      assert user.name == attrs.name
      assert user.email == attrs.email
      assert user.account.balance == 100000
    end

    test "fail if name is invalid" do
      attrs = %{
        name: "Ab",
        email: "ab@email.com.br"
      }

      assert {:error, changeset} = Accounts.create(attrs)
      refute changeset.valid?

      errors = errors_on(changeset)

      assert ["should be at least 3 character(s)"] == errors[:name]
    end

    test "fail if e-mail is invalid" do
      attrs = %{
        name: "Maria José",
        email: "maria_email.com.br"
      }

      assert {:error, changeset} = Accounts.create(attrs)
      refute changeset.valid?

      errors = errors_on(changeset)

      assert ["has invalid format"] == errors[:email]
    end

    test "fail if invalid data" do
      assert {:error, changeset} = Accounts.create(%{})
      refute changeset.valid?

      errors = errors_on(changeset)
      assert ["can't be blank"] == errors[:name]
      assert ["can't be blank"] == errors[:email]
    end
  end
end
