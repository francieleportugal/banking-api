defmodule BankingApi.Accounts do
  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end
end
