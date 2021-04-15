# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankingApi.Repo.insert!(%BankingApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require BankingApi.Operations

alias BankingApi.Operations
alias BankingApi.Accounts.Schemas.Operation
alias BankingApi.Repo

operations = [
  %Operation{id: Operations.cash_withdrawal, description: "Cash withdrawal"},
  %Operation{id: Operations.transfer, description: "Transfer"}
]

Enum.each(operations, &Repo.insert!(&1))
