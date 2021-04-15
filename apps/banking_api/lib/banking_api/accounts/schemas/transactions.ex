defmodule BankingApi.Accounts.Schemas.Transactions do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Accounts.Schemas.Operation

  @required [:value]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :value, :integer

    belongs_to :operation, Operation
    belongs_to :origin_account, Account
    belongs_to :destination_account, Account

    timestamps()
  end

  @doc false
  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
