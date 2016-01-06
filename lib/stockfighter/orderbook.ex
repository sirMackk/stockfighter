defmodule Stockfighter.Orderbook do
  # how can this be a time-series map?
  def start_link(venue) do
    Agent.start_link(fn -> HashDict.new end, name: venue)
  end

  def get_price(venue, stock) do
    Agent.get(venue, &Dict.fetch(&1, stock))
  end
  def update(venue, stock, price) do
    Agent.update(venue, fn (dict) -> 
      Dict.put(dict, stock, price)
    end)
  end
end
