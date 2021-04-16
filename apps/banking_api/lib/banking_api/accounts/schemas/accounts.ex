defmodule BankingApi.Accounts.Schemas.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.Accounts.Schemas.User

  @required [:balance]

  @derive {Jason.Encoder, except: [:__meta__, :user]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :integer

    belongs_to :user, User

    timestamps()

  end

  def changeset_update_balance(model \\ %__MODULE__{}, new_balance) do
    model
    |>change(balance: new_balance)
    |>validate_required(@required)
    |>validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
