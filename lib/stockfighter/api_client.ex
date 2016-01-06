defmodule Stockfighter.ApiClient do
  alias Stockfighter.Orderbook, as: Orderbook

  @api_key Application.get_env(:stockfighter, :api_key)
  @api_url Application.get_env(:stockfighter, :api_url)
  @wss_url "wss://api.stockfighter.io/ob/api/ws"
  @headers [{"User-agent", "pr0tagon1st/stockfighter/elixirlang"},
            {"X-Starfighter-Authorization", @api_key}]

  defp venue_stock_url(venue) do
    @api_url <> "/venues/#{venue}/stocks"
  end

  defp orderbook_url(venue, stock) do
    @api_url <> "/venues/#{venue}/stocks/#{stock}"
  end

  defp new_order_url(venue, stock) do
    @api_url <> "/venues/#{venue}/stocks/#{stock}/orders"
  end

  defp tickertape_url(account, venue) do
    @wss_url <> "/#{account}/venues/#{venue}/tickertape"
  end

  defp stock_tickertape(account, venue, stock) do
    @wss_url <> "/#{account}/venues/#{venue}/tickertape/stocks/#{stock}"
  end

  defp stock_quote(venue, stock) do
    @api_url <> "/venues/#{venue}/stocks/#{stock}/quote"
  end

  def get_stocks_for(venue) do
    venue_stock_url(venue)
      |> HTTPoison.get(@headers)
  end

  def get_order_book_stock(venue, stock) do
    orderbook_url(venue, stock)
      |> HTTPoison.get(@headers)
  end

  def get_quote_for(venue, stock) do
    get_quote_for(venue, stock)
      |> HTTPoison.get(@headers)
  end

  def buy_stock_limit(venue, stock, qty, price, acc) do
    post_new_order(venue, stock, qty, price, acc, "buy")
  end

  def sell_stock(venue, stock, qty, price, acc) do
    post_new_order(venue, stock, qty, price, acc, "sell")
  end

  defp post_new_order(venue, stock, qty, price, acc, direction) do
    new_order_url(venue, stock)
      |> HTTPoison.post(@headers)
  end
end
