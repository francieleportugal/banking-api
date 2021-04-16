defmodule BankingApi.Accounts.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.Accounts.Schemas.Account

  @initial_balance 100000

  @required [:name, :email]

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string

    timestamps()

    has_one :account, Account
  end

  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |>cast(attrs, @required)
    |>put_assoc(:account, %Account{balance: @initial_balance})
    |>validate_required(@required)
    |>validate_length(:name, min: 3)
    |>validate_format(:email, ~r/^[A-Za-z0-9._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/)
  end
end
