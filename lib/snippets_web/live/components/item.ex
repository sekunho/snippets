defmodule SnippetsWeb.Components.Item do
  use Surface.Component
  alias Surface.Components.LivePatch

  def render(assigns) do
    ~H"""
    <LivePatch to="#">
      <div class="flex flex-col p-4 hover:bg-gruvbox-bg3 hover:bg-opacity-10">
        <span class="text-gruvbox-fg leading-none font-mono">
          New snippet
        </span>
        <span class="text-gruvbox-bg3">
          Just now
        </span>
      </div>
    </LivePatch>
    """
  end
end
