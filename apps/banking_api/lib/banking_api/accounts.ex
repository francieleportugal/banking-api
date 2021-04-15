defmodule BankingApi.Accounts do
  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.User
  alias BankingApi.Accounts.Schemas.Account

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
end
