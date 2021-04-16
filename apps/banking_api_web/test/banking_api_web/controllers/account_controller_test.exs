defmodule BankingApiWeb.AccountControllerTest do
  require BankingApi.Operations

  use BankingApiWeb.ConnCase

  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.User
  alias BankingApi.Operations

  setup %{conn: conn} do
    user = Repo.insert!(%User{
      name: "Yan Cardoso",
      email: "yan@email.com"
    })

    account = Ecto.build_assoc(user, :account, balance: 100000)
    account = Repo.insert!(account)

    {:ok, conn: conn, origin_account_id: account.id}
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
end
