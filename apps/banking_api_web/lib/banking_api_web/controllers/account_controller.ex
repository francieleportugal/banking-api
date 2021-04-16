defmodule BankingApiWeb.AccountController do
  use BankingApiWeb, :controller

  require BankingApiWeb.ErrorMessages

  alias BankingApi.Accounts
  alias BankingApiWeb.ErrorMessages
  alias BankingApiWeb.InputValidation
  alias BankingApi.Accounts.Inputs

  def create(conn, params) do
    with {:ok, user} <- Accounts.create(params) do
      send_json(conn, 200, user)
    else
      {:error, %Ecto.Changeset{}} -> send_json(conn, 400, ErrorMessages.invalid_data)
    end
  end

  def withdraw_money(conn, params) do
    with {:ok, input} <- InputValidation.cast_and_apply(params, Inputs.WithdrawMoney),
      {:ok, operation} <- Accounts.withdraw_money(input) do
      send_json(conn, 200, operation)
    else
      {:error, %Ecto.Changeset{}} -> send_json(conn, 400, ErrorMessages.invalid_data)
    end
  end

  # TODO become a helper
  def send_json(conn, status, body) do
    conn
    |>put_resp_header("content-type", "application/json")
    |>send_resp(status, Jason.encode!(body))
  end
end
