defmodule BankingApi.Accounts.Inputs.WithdrawMoney do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:value, :origin_account_id]

  @primary_key false
  embedded_schema do
    field :value, :integer
    field :origin_account_id, :string
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |>cast(params, @required)
    |>validate_required(@required)
    |>validate_number(:value, greater_than: 0)
  end
end
