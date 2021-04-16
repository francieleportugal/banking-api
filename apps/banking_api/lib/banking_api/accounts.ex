defmodule BankingApi.Accounts do
  require BankingApi.Operations

  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.User
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Accounts.Schemas.Transaction
  alias BankingApi.Operations
  alias BankingApi.Accounts.Inputs

  def create(attrs \\ %{}) do
    attrs
    |>User.changeset()
    |>Repo.insert()
  end

  def withdraw_money(%Inputs.WithdrawMoney{} = attrs) do
    account = Repo.get(Account, attrs.origin_account_id)

    input = %{
      operation_id: Operations.cash_withdrawal,
      value: attrs.value,
      origin_account_id: attrs.origin_account_id
    }

    with {:ok, transaction} <- create_transaction(input),
      {:ok, updated_account} <- decrease_balance(account, input.value) do
        {:ok, %{account: updated_account, transaction: transaction}}
    else
      %{valid?: false} = changeset -> {:error, changeset}
      {:error, error} -> {:error, error}
    end
  end

  def transfer(%Inputs.Transfer{} = attrs) do
    origin_account = Repo.get(Account, attrs.origin_account_id)
    destination_account = Repo.get(Account, attrs.destination_account_id)

    input = %{
      operation_id: Operations.transfer,
      value: attrs.value,
      origin_account_id: attrs.origin_account_id,
      destination_account_id: attrs.destination_account_id
    }

    with {:ok, transaction} <- create_transaction(input, Operations.transfer),
      {:ok, updated_origin_account} <- decrease_balance(origin_account, input.value),
      {:ok, updated_destination_account} <- increase_balance(destination_account, input.value) do
        {
          :ok,
          %{
            origin_account: updated_origin_account,
            destination_account: updated_destination_account,
            transaction: transaction
          }
        }
    else
      %{valid?: false} = changeset -> {:error, changeset}
      {:error, error} -> {:error, error}
    end
  end

  defp create_transaction(attrs) do
    attrs
    |>Transaction.changeset()
    |>Repo.insert()
  end

  defp create_transaction(attrs, Operations.transfer) do
    attrs
    |>Transaction.changeset_create_transfer()
    |>Repo.insert()
  end

  defp decrease_balance(%Account{} = account, value) do
    case value > account.balance do
      true -> {:error, :insufficient_funds}
      false -> (
        new_balance = account.balance - value

        account
        |>Account.changeset_update_balance(new_balance)
        |>Repo.update()
      )
    end
  end

  defp increase_balance(%Account{} = account, value) do
    new_balance = account.balance + value

    account
    |>Account.changeset_update_balance(new_balance)
    |>Repo.update()
  end
end
