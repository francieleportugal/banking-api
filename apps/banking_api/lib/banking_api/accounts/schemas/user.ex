defmodule BankingApi.Accounts.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required [:name, :email]

  # @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string
    timestamps()

    # has_one :account, Account
  end

  @doc false
  def changeset(model = %__MODULE__{}, attrs) do
    model
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
