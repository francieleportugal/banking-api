defmodule BankingApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid), null: false
      add :balance, :integer, default: 0

      timestamps()
    end
  end
end
