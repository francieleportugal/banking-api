defmodule BankingApi.Accounts.Inputs.Transfer do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:value, :origin_account_id, :destination_account_id]

  @primary_key false
  embedded_schema do
    field :value, :integer
    field :origin_account_id, :string
    field :destination_account_id, :string
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |>cast(params, @required)
    |>validate_required(@required)
    |>validate_number(:value, greater_than: 0)
    |>validate_accounts()
  end

  defp validate_accounts(%{valid?: false} = changeset) do
    changeset
  end

  defp validate_accounts(changeset) do
    origin_account_id = get_change(changeset, :origin_account_id)
    destination_account_id = get_change(changeset, :destination_account_id)

    if origin_account_id == destination_account_id do
      IO.puts("entrei")
      add_error(changeset, :destination_account_id, "Destination account must be different of origin account")
    else
      changeset
    end
  end
end
