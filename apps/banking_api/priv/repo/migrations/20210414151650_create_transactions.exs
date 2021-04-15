defmodule BankingApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :operation_id, references(:operations, type: :uuid), null: false
      add :origin_account_id, references(:accounts, type: :uuid), null: false
      add :destination_account_id, references(:accounts, type: :uuid)
      add :value, :integer, null: false

      timestamps()
    end
  end
end
