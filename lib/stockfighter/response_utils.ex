defmodule Stockfighter.ResponseUtils do
  require Logger
  def pick_first_symbol({:ok, stock_response}) when is_list(stock_response) do
    List.first(stock_response[:symbols])[:symbol]
  end

  def get_price({:ok, quote_response}) when is_list(quote_response) do
    quote_response[:last]
  end
end
