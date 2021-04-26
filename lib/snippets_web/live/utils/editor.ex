defmodule SnippetsWeb.Utils.Editor do
  @modes [:insert, :normal]

  def modes, do: @modes
  def insert, do: :insert
  def normal, do: :normal

  def display_mode(mode) when mode in @modes do
    case mode do
      :insert -> "INSERT"
      :normal -> "NORMAL"
    end
  end
end
