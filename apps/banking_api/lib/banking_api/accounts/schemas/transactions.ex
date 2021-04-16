defmodule BankingApi.Accounts.Schemas.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Accounts.Schemas.Operation

  @required [:value, :operation_id, :origin_account_id]

  # fix: remove :operation, :origin_account, :destination_account
  @derive {Jason.Encoder, except: [:__meta__, :operation, :origin_account, :destination_account]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :value, :integer

    belongs_to :operation, Operation, foreign_key: :operation_id
    belongs_to :origin_account, Account, foreign_key: :origin_account_id, type: Ecto.UUID
    belongs_to :destination_account, Account

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |>cast(attrs, @required)
    |>validate_required(@required)
    |>validate_number(:value, greater_than: 0)
    |>foreign_key_constraint(:operation_id)
    |>foreign_key_constraint(:origin_account_id)
  end
end
