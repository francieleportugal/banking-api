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
      {:ok, updated_account} <- update_balance(account, input.value) do
        {:ok, account: updated_account, transaction: Repo.preload(transaction, :origin_account)}
    else
      %{valid?: false} = changeset ->
        {:error, changeset}

      {:error, error} ->
        {:error, error}
    end

    # {:ok, updated_account} = account
    # |>Account.changeset_update_balance(get_new_balance(account.balance, input.value))
    # |>Repo.update()

    # {:ok, transaction} = input
    # |>Transaction.changeset()
    # |>Repo.insert()

    # {:ok, account: updated_account, transaction: transaction}

  end

  defp create_transaction(attrs \\ %{}) do
    attrs
    |>Transaction.changeset()
    |>Repo.insert()
  end

  defp update_balance(account, withdrawal_value) do
    new_balance = get_new_balance(account.balance, withdrawal_value)

    account
    |>Account.changeset_update_balance(new_balance)
    |>Repo.update()
  end

  defp get_new_balance(current_balance, withdrawal_value) do
    if withdrawal_value > current_balance do
      {:error, :insufficient_funds}
    end

    current_balance - withdrawal_value
  end
end
