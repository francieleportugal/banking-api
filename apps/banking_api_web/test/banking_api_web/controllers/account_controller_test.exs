defmodule BankingApiWeb.AccountControllerTest do
  use BankingApiWeb.ConnCase

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
end
