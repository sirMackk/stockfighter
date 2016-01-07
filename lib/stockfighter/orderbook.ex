defmodule Stockfighter.Orderbook do
  def start_link(venue) do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
  end

  def get_price(stock) do
    Agent.get(__MODULE__, &Map.fetch(&1, stock)) |> hd
  end
  def update(stock, data) do
    Agent.update(__MODULE__, fn (dict) ->
      Map.update(dict, stock, [data], &([data] ++ &1))
    end)
  end
end
