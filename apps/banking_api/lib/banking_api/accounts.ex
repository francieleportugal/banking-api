defmodule BankingApi.Accounts do
  require BankingApi.Operations

  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.User
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Accounts.Schemas.Transaction
  alias BankingApi.Operations
  alias BankingApi.Accounts.Inputs

  @initial_balance 100000

  def create(attrs \\ %{}) do
    with %{valid?: true} = changeset <- User.changeset(attrs),
      %{valid?: true} = changeset <- Ecto.Changeset.put_assoc(changeset, :account, %Account{balance: @initial_balance}),
      {:ok, account} <- Repo.insert(changeset) do
        {:ok, account}
      else
        %{valid?: false} = changeset -> {:error, changeset}
      end
  end

  def withdraw_money(%Inputs.WithdrawMoney{} = attrs) do
    # IO.inspect("-------")
    # IO.inspect(attrs)
    input = %{
      operation_id: Operations.cash_withdrawal,
      value: attrs.value,
      origin_account_id: attrs.origin_account_id
    }

    # IO.inspect(transaction)

    with %{valid?: true} = changeset <- Transaction.changeset(input),
      {:ok, transaction} <- Repo.insert!(changeset) do
        {:ok, transaction}
      else
        %{valid?: false} = changeset -> {:error, changeset}
    end

  end
end
