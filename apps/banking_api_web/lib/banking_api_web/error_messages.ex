defmodule BankingApiWeb.ErrorMessages do
  defmacro invalid_data, do: quote do: %{type: "invalid_data", description: "Invalid data"}
end
