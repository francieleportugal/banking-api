defmodule BankingApiWeb.AccountController do
  use BankingApiWeb, :controller

  alias BankingApi.Accounts

  def create(conn, params) do
    with {:ok, user} <- Accounts.create(params) do
      send_json(conn, 200, user)
    else
      {:error, %Ecto.Changeset{}} ->
        msg = %{type: "invalid_data", description: "Invalid data"}
        send_json(conn, 400, msg)
    end
  end

  # TODO become a helper
  def send_json(conn, status, body) do
    conn
    |>put_resp_header("content-type", "application/json")
    |>send_resp(status, Jason.encode!(body))
  end
end
