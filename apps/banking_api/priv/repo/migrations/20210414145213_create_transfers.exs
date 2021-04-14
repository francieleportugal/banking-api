defmodule BankingApi.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :origin_account_id, references(:accounts, type: :uuid), null: false
      add :destination_account_id, references(:accounts, type: :uuid), null: false
      add :value, :integer, null: false

      timestamps()
    end
  end
end
