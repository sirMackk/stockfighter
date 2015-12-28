defmodule Stockfigher.CLI do
  @api_key Application.get_env(:stockfighter, :api_key)
  @api_url Application.get_env(:stockfighter, :api_url)
  @wss_url "wss://api.stockfighter.io/ob/api/ws"
  @headers [{"User-agent", "pr0tagon1st/stockfighter/elixirlang"},
            {"X-Starfighter-Authorization", @api_key}]

  def main(args) do
    args
      |> parse_args
      |> process
  end

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

  def get_stocks_for(venue) do
    venue_stock_url(venue)
      |> HTTPoison.get(@headers)
      |> handle_get_response
  end

  def get_order_book_stock(venue, stock) do
    orderbook_url(venue, stock)
      |> HTTPoison.get(@headers)
      |> handle_get_response
  end

  def buy_stock(venue, stock, qty, price, acc) do
    post_new_order(venue, stock, qty, price, acc, "buy")
  end

  def sell_stock(venue, stock, qty, price, acc) do
    post_new_order(venue, stock, qty, price, acc, "sell")
  end

  defp post_new_order(venue, stock, qty, price, acc, direction) do
    new_order_url(venue, stock)
      |> HTTPoison.post(@headers)
      |> handle_post_response
  end

  # move above out of this module, this should only have top level cli cmds
  # venue_setup =
  # get stocks on venue, get orderbooks for each stock (or specific stock)
  # get tickertape updates to stock
  # execute actions
end
