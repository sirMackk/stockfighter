defmodule Stockfighter.IdbApi do
  require Logger

  @db_name "stockfighter"

  defp influxdb_url do
    "http://localhost:8086/write?db=#{@db_name}&precision=u"
  end

  def insert_line(data) do
    influxdb_url
      |> HTTPoison.post(data |> line_proto_serialize)
      |> handle_response
  end

  defp line_proto_serialize(data) when is_list(data) do
    ~c(quote,venue=#{data[:venue]},symbol=#{data[:symbol]} ) ++
    optional_elements(data, "bid") ++
    optional_elements(data, "ask") ++
    ~c(lastSize=#{data[:lastSize]},lastTrade=#{micro_s_epoch(data[:lastTrade])} ) ++
    ~c(#{micro_s_epoch(data[:quoteTime])})
  end

  defp optional_elements(data, type) do
    import String, only: [to_atom: 1]
    case Keyword.has_key?(data, to_atom(type)) do
      true ->
      ~c(#{type}=#{data[to_atom(type)]},) ++
      ~c(#{type}Size=#{data[to_atom(type <> "Size")]},) ++
      ~c(#{type}Depth=#{data[to_atom(type <> "Depth")]},)
      _ -> ''
    end
  end

  defp micro_s_epoch(datetime) when is_binary(datetime) do
    use Timex
    datetime
      |> DateFormat.parse!("{ISOz}") 
      |> DateFormat.format!("%s%f", :strftime)
      |> String.to_char_list
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 204, body: _}}), do: nil

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: reason}}), do: log_error(reason)

  def handle_response({:ok, %HTTPoison.Response{status_code: 400, body: reason}}), do: log_error(reason)
  def handle_response({:error, %HTTPoison.Error{reason: reason}}), do: log_error(reason)

  defp log_error(reason) do
    Logger.error("""
      Error - request not understood by influxdb:
      #{inspect(reason)}
      """)
  end
end
