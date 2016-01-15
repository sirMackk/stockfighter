# Stockfighter

This is an ongoing set of tools to interact with [Stockfighter](https://www.stockfighter.io) via the public API. I build these out as I work on the levels in the game - this means that a lot of the API isn't yet covered. *Warning:* I'm using this as a chance to learn Elixir so the code is far from clean production form - it's all exploratory.

Here's what's covered:

#### Getting stocks off a venue.

```elixir
stocks = Stockfighter.ApiClient.get_stock_for("TESTEX")
```

#### Getting quotes for a stock.

```elixir
price = Stockfighter.ApiClient.get_quote_for("TESTEX", "TESTSTOCK")
```

#### Posting orders.

```elixir
order = %Stockfighter.Order{venue: venue, stock: stock_symbol, account: account,
                            qty: @qty, direction: "buy", orderType: "limit",
                            price: updated_price}

Stockfighter.ApiClient.post_new_order(order)
```

#### Websocket client

You can use any of the websocket urls (tickertape, executions) and a callback that will be run for each received message:

```elixir
tickertape_url(account, venue)
  |> Stockfighter.WebsocketClient.run(&tickertape_influx/1)
```

##### tools/quote_processor.ex

I made a tool to consume the quote websocket - `Stockfighter.Tools.QuoteProcessor`. It can dump the data into [InfluxDB](https://influxdata.com/), [ElasticSearch](https://www.elastic.co/products/elasticsearch), or to the terminal. It's currenly hardcoded to push data to a "stockfigher" InfluxDB database. It's easy to modify though.

To use it, just run `./stockfighter --action quote-proc --venue VENUEX --acc ASKJDHASD98123`


#### Other

There's a few other items in this codebase, but I hope that by not including them in the README I am signalling how protoypical they are and likely to be deleted or completely changed.



##### License
Copyright (C) 2015 sirMackk

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
