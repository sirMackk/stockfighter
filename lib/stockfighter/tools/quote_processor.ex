defmodule Stockfighter.Tools.QuoteProcessor do
  require Logger

  import Stockfighter.IdbApi, only: [insert_line: 1]
  import Stockfighter.EsApi, only: [insert_document: 2]
  import Stockfighter.ApiClient, only: [get_stocks_for: 1, tickertape_url: 2]

  def run(vargs) do
    [venue: venue, acc: account] = vargs

    tickertape_url(account, venue)
      |> Stockfighter.WebsocketClient.run(&tickertape_influx/1)
  end


  def tickertape_prn(data) do
    data 
      |> :jsx.decode([{:labels, :atom}])
      |> inspect
      |> Logger.info
    end

  def tickertape_es(data) do
    insert_document("stockfighter", data)
  end

  def tickertape_influx(data) do
    insert_line(:jsx.decode(data, [{:labels, :atom}])[:quote])
  end
end
