defmodule SnippetsWeb.SnippetsLive.Index do
  use Surface.LiveView
  alias SnippetsWeb.Components.Item


  def render(assigns) do
    ~H"""
    <div class="flex">
      <div class="snippets-list">
        <Item :for={{ _ <- 1..500 }} />
      </div>
      <div class="editor w-full lg:w-5/6">
        <textarea placeholder="IO.puts \"Hello, world!\"" class="h-full w-full outline-none px-2 bg-transparent resize-none placeholder-gruvbox-bg3"/>
      </div>
    </div>
    """
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end
end
