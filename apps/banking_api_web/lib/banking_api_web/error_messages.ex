defmodule BankingApiWeb.ErrorMessages do
  defmacro invalid_data, do: quote do: %{type: "invalid_data", description: "Invalid data"}
  defmacro insufficient_funds, do: quote do: %{type: "insufficient_funds", description: "Insuficient funds"}
end
