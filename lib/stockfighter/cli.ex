defmodule Stockfighter.CLI do

  def main(args) do
    args
      |> process_args
  end

  defp process_args(args) do
    {parsed, _, _} = OptionParser.parse(args, switches: [level: :string])

    case Keyword.pop(parsed, :action) do
      {"one", rest} ->
        Stockfighter.Solutions.One.run(rest)
      {"two", rest} ->
        Stockfighter.Solutions.Two.run(rest)
      {"quote-proc", rest} ->
        Stockfighter.Tools.QuoteProcessor.run(rest)
      {"exec-proc", rest} ->
        Stockfighter.Tools.ExecutionProcessor.run(rest)
      _ -> help
    end
  end


  defp help do
    IO.puts """
    Solutions:
    one - args: venue, acc
    two - args: venue, acc, pr

    Tools:
    quote-proc - args: venue, acc
    """
  end
end

