defmodule BankingApi.Operations do
  @cash_withdrawal "e1eaecbf-bc86-4b26-b5d8-bb291b5ced04"
  @transfer "c6be16bd-f3be-4019-9734-09967ce554a6"

  defmacro cash_withdrawal, do: @cash_withdrawal
  defmacro transfer, do: @transfer
end
