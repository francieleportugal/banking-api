defmodule BankingApi.Accounts.Schemas.Transfers do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.Accounts.Schemas.Account

  @required [:value]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transfers" do
    field :value, :integer

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
