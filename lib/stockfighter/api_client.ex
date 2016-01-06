defmodule Stockfighter.ApiClient do
  require Logger
  alias Stockfighter.Orderbook, as: Orderbook

  @api_key Application.get_env(:stockfighter, :api_key)
  @api_url Application.get_env(:stockfighter, :api_url)
  @wss_url "wss://api.stockfighter.io/ob/api/ws"
  @headers [{"User-agent", "pr0tagon1st/stockfighter/elixirlang"},
            {"X-Starfighter-Authorization", @api_key}]
  @json_header {"Content-Type", "application/json"}

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
      |> handle_response
  end

  def get_order_book_stock(venue, stock) do
    orderbook_url(venue, stock)
      |> HTTPoison.get(@headers)
  end

  def get_quote_for(venue, stock) do
    Logger.info("Getting quote for #{venue}/#{stock}")
    get_quote_for(venue, stock)
      |> HTTPoison.get(@headers)
      |> handle_response
  end

  #def sell_stock(venue, stock, qty, price, acc) do
    #post_new_order(venue, stock, qty, price, acc, "sell")
  #end

  def post_new_order(order) when is_map(order) do
    new_order_url(order.venue, order.stock)
      |> HTTPoison.post(:jsx.encode(Map.from_struct(order)), @headers ++ @json_header)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, :jsx.decode(body)}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
