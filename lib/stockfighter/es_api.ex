defmodule Stockfighter.EsApi do
  require Logger
  
  @headers [{"Content-Type", "application/json"}]

  defp es_url do
    "http://localhost:9200"
  end

  defp index_url(index) do
    es_url <> "/#{index}/quote/"
  end

  def insert_document(index, doc) do
    index_url(index)
      |> HTTPoison.post(doc, @headers)
      |> handle_response
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 201, body: body }}), do: nil

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    Logger.error("Error when inserting document into elastic search")
    Logger.error(inspect(reason))
  end
end

