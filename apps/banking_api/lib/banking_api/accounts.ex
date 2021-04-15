defmodule BankingApi.Accounts do
  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.User

  def create_user(attrs \\ %{}) do
    with %{valid?: true} = changeset <- User.changeset(attrs),
      {:ok, user} <- Repo.insert(changeset) do
        {:ok, user}
      else
        %{valid?: false} = changeset -> {:error, changeset}
      end
  end
end
