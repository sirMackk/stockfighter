defmodule Stockfighter.CLI do

  def main(args) do
    args
      |> process_args
  end

  defp process_args(args) do
    {parsed, _, _} = OptionParser.parse(args, switches: [level: :string])

    case Keyword.pop(parsed, :level) do
      "one" ->
        Stockfighter.Levels.One.run(parsed)
      _ -> help
    end
  end


  defp help do
    IO.puts "This is help"
  end

  # check when order is filled
end

