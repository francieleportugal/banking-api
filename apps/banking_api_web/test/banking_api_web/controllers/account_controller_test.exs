defmodule BankingApiWeb.AccountControllerTest do
  require BankingApi.Operations

  use BankingApiWeb.ConnCase

  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.User
  alias BankingApi.Operations

  setup %{conn: conn} do
    user1 = Repo.insert!(%User{
      name: "Yan Cardoso",
      email: "yan@email.com"
    })
    user2 = Repo.insert!(%User{
      name: "Cândido Santana",
      email: "joao@email.com"
    })
    user3 = Repo.insert!(%User{
      name: "Leandro Santana",
      email: "leandro@email.com"
    })

    account1 = Ecto.build_assoc(user1, :account, balance: 100000)
    account2 = Ecto.build_assoc(user2, :account, balance: 264789)
    account3 = Ecto.build_assoc(user3, :account, balance: 0)

    account1 = Repo.insert!(account1)
    account2 = Repo.insert!(account2)
    account3 = Repo.insert!(account3)

    {
      :ok,
      conn: conn,
      origin_account_id: account1.id,
      origin_account_id_to_transfer: account2.id,
      destination_account_id_to_transfer: account3.id
    }
  end

  describe "POST api/accounts" do
    test "create account with valid data", ctx do
      input = %{"name" => "Maria Lúcia", "email" => "maria@email.com"}

      assert user = ctx.conn
          |>post("api/accounts", input)
          |>json_response(200)

      assert user["name"] == input["name"]
      assert user["email"] == input["email"]
      assert user["account"]["balance"] == 100000
    end

    test "create account with invalid data", ctx do
      assert ctx.conn
          |>post("api/accounts", %{name: "Ab"})
          |>json_response(400) == %{
            "description" => "Invalid data",
            "type" => "invalid_data"
          }
    end
  end

  describe "POST api/cash-withdrawal" do
    test "Withdraw money with valid data", ctx do
      input = %{
        value: 50000,
        origin_account_id: ctx[:origin_account_id]
      }

      assert %{"account" => account, "transaction" => transaction} = ctx.conn
        |>post("api/cash-withdrawal", input)
        |>json_response(200)

      assert account["balance"] == 50000
      assert transaction["operation_id"] == Operations.cash_withdrawal
      assert transaction["origin_account_id"] == input.origin_account_id
      assert transaction["destination_account_id"] == nil
    end

    test "fail if insuficient funds", ctx do
      input = %{
        value: 10000000,
        origin_account_id: ctx[:origin_account_id]
      }

      assert ctx.conn
        |>post("api/cash-withdrawal", input)
        |>json_response(422) == %{
          "description" => "Insuficient funds",
          "type" => "insufficient_funds"
        }
    end

    test "fail if value equal to zero", ctx do
      input = %{
        value: 0,
        origin_account_id: ctx[:origin_account_id]
      }

      assert ctx.conn
        |>post("api/cash-withdrawal", input)
        |>json_response(400) == %{
          "description" => "Invalid data",
          "type" => "invalid_data"
        }
    end

    test "fail if data are missing", ctx do
      assert ctx.conn
        |>post("api/cash-withdrawal", %{})
        |>json_response(400) == %{
          "description" => "Invalid data",
          "type" => "invalid_data"
        }
    end
  end

  describe "POST api/transfer" do
    test "Transfer with valid data", ctx do
      input = %{
        value: 50000,
        origin_account_id: ctx[:origin_account_id_to_transfer],
        destination_account_id: ctx[:destination_account_id_to_transfer]
      }

      assert %{
        "origin_account" => origin_account,
        "destination_account" => destination_account,
        "transaction" => transaction
      } = ctx.conn
        |>post("api/transfer", input)
        |>json_response(200)


      assert transaction["operation_id"] == Operations.transfer()
      assert transaction["origin_account_id"] == input.origin_account_id
      assert transaction["destination_account_id"] == input.destination_account_id
      assert origin_account["balance"] == 214789
      assert destination_account["balance"] == 50000
    end

    test "Transfer fail if insuficient funds", ctx do
      input = %{
        value: 99999999,
        origin_account_id: ctx[:origin_account_id_to_transfer],
        destination_account_id: ctx[:destination_account_id_to_transfer]
      }

      assert ctx.conn
        |>post("api/transfer", input)
        |>json_response(422) == %{
          "description" => "Insuficient funds",
          "type" => "insufficient_funds"
        }
    end

    test "Transfer fail if value equal to zero", ctx do
      input = %{
        value: 0,
        origin_account_id: ctx[:origin_account_id_to_transfer],
        destination_account_id: ctx[:destination_account_id_to_transfer]
      }

      assert ctx.conn
        |>post("api/transfer", input)
        |>json_response(400) == %{
          "description" => "Invalid data",
          "type" => "invalid_data"
        }
    end

    test "Transfer fail if data are missing", ctx do
      assert ctx.conn
        |>post("api/transfer", %{})
        |>json_response(400) == %{
          "description" => "Invalid data",
          "type" => "invalid_data"
        }
    end

    test "Transfer fail if origin account and destination account are equals", ctx do
      input = %{
        value: 17894,
        origin_account_id: ctx[:origin_account_id_to_transfer],
        destination_account_id: ctx[:origin_account_id_to_transfer]
      }

      assert ctx.conn
        |>post("api/transfer", input)
        |>json_response(400) == %{
          "description" => "Invalid data",
          "type" => "invalid_data"
        }
    end
  end
end
