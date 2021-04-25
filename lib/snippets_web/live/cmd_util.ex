defmodule SnippetsWeb.CmdUtil do
  @spec recognized_command?(binary) :: boolean | {false, binary}
  def recognized_command?(cmd) when is_binary(cmd) do
    cmd
    |> parse_command()
    |> case do
      ["save", _file_name] ->
        true

      ["save" | _] ->
        {false, "Expecting 1 argument. e.g `save example.txt`"}

      ["commands"] ->
        true

      _ ->
        {false, "Unrecognized command. Type `commands` for the list of commands."}
    end
  end

  @spec parse_command(binary) :: [binary]
  def parse_command(cmd) when is_binary(cmd) do
    String.split(cmd, " ", trim: true)
  end

  def editor_height_class(open?) do
    case open? do
      true ->
        "with-cmd"

      false ->
        "without-cmd"
    end
  end

  def cmd_class(maybe_valid?) do
    case maybe_valid? do
      nil -> ""
      true -> "text-gruvbox-green"
      false -> "text-gruvbox-red"
    end
  end
end
