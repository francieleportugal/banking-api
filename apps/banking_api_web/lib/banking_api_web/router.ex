defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankingApiWeb do
    pipe_through :api

    post "/accounts", AccountController, :create
    post "/cash-withdrawal", AccountController, :withdraw_money
    # post "/transfer", AccountController, :transfer
  end
end
