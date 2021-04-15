defmodule BankingApi.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create table(:operations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :description, :string, null: false

      timestamps()
    end
  end
end
