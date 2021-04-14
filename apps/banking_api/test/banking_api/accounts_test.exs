defmodule BankingApi.AccountsTest do
  use BankingApi.DataCase

  alias BankingApi.Accounts

  describe "create_user/1" do
    test "create a user with valid data without account" do
      attrs = %{
        name: "João das Neves",
        email: "joao@email.com.br"
      }

      user = Accounts.create_user(attrs)

      assert user.name == attrs.name
      assert user.email == attrs.email
    end
  end
end
