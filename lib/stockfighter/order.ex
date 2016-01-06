defmodule Stockfighter.Order do
  defstruct [:venue, :stock, :qty, :price, :account, :direction, :orderType]
end
