defmodule BankingApi.Accounts.Schemas.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.Accounts.Schemas.User

  @required [:balance]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :integer

    belongs_to :user, User

    timestamps()

  end

  @doc false
  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
