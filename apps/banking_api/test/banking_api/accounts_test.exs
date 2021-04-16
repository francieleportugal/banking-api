defmodule BankingApi.AccountsTest do
  require BankingApi.Operations

  use BankingApi.DataCase

  alias BankingApi.Accounts
  alias BankingApi.Accounts.Inputs
  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.User
  alias BankingApi.Operations

  setup do
    user = Repo.insert!(%User{
      name: "Laís Souza",
      email: "lais@email.com"
    })

    account = Ecto.build_assoc(user, :account, balance: 100000)
    account = Repo.insert!(account)

    {:ok, origin_account_id: account.id}
  end

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

  describe "withdraw_money/1" do
    test "Withdraw money with valid data", state do
      input = %Inputs.WithdrawMoney{
        value: 100,
        origin_account_id: state[:origin_account_id]
      }

      assert {
        :ok,
        account: account,
        transaction: transaction
      } = Accounts.withdraw_money(input)
      IO.inspect(transaction)
      assert transaction.operation_id == Operations.cash_withdrawal
      assert transaction.origin_account_id == input.origin_account_id
      assert transaction.value == input.value

      assert account.balance == 99900
    end

    test "fail if value equal to zero", state do
      input = %Inputs.WithdrawMoney{
        value: 0,
        origin_account_id: state[:origin_account_id]
      }

      assert {:error, changeset} = Accounts.withdraw_money(input)

      errors = errors_on(changeset)
      assert ["must be greater than 0"] == errors[:value]
    end

    test "fail if value less than zero", state do
      input = %Inputs.WithdrawMoney{
        value: -1,
        origin_account_id: state[:origin_account_id]
      }

      assert {:error, changeset} = Accounts.withdraw_money(input)

      errors = errors_on(changeset)
      assert ["must be greater than 0"] == errors[:value]
    end

    test "fail if origin account doesn't exist" do
      input = %Inputs.WithdrawMoney{
        value: 100,
        origin_account_id: "167c9001-5447-4b0b-94d0-ab8f67d47626"
      }

      assert {:error, changeset} = Accounts.withdraw_money(input)

      errors = errors_on(changeset)
      assert ["does not exist"] == errors[:origin_account_id]
    end
  end
end
