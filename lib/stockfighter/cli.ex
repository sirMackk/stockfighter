defmodule Stockfigher.CLI do

  def main(args) do
    args
      |> parse_args
      |> process
  end
  # add argparser



  # venue_setup =
  # get stocks on venue, get orderbooks for each stock (or specific stock)
  # execute actions - actions - actions happen on conditions when something about stock or time happens
end

