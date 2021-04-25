defmodule SnippetsWeb.Components.Item do
  use Surface.Component
  alias Surface.Components.LivePatch

  def render(assigns) do
    ~H"""
    <LivePatch to="#">
      <div class="flex flex-col text-sm p-4 hover:bg-gruvbox-bg3 hover:bg-opacity-10 font-mono">
        <span class="text-gruvbox-fg leading-none">
          Some snippet name
        </span>
        <span class="text-gruvbox-bg3">
          Yesterday
        </span>
      </div>
    </LivePatch>
    """
  end
end
