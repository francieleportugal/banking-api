defmodule BankingApi.Accounts.Schemas.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Accounts.Schemas.Operation

  @required [:value, :operation_id, :origin_account_id]

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
    IO.inspect(attrs)
    model
    |>cast(attrs, @required)
    |>validate_required(@required)
    |>assoc_constraint(:operation_id)
    |>assoc_constraint(:origin_account_id)
  end
end
