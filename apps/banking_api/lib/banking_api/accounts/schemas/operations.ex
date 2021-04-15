defmodule BankingApi.Accounts.Schemas.Operation do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "operations" do
    field :description, :string

    timestamps()
  end
end
