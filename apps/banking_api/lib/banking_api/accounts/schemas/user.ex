defmodule BankingApi.Accounts.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.Accounts.Schemas.User

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
  def changeset(%User{} = model, attrs) do
    model
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
