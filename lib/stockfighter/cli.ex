defmodule Stockfighter.CLI do

  def main(args) do
    args
      |> process_args
  end

  defp process_args(args) do
    {parsed, _, _} = OptionParser.parse(args, switches: [level: :string])

    IO.inspect Keyword.pop(parsed, :level)
    case Keyword.pop(parsed, :level) do
      {"one", rest} ->
        Stockfighter.Levels.One.run(rest)
      _ -> help
    end
  end


  defp help do
    IO.puts "This is help"
  end

  # check when order is filled
end

