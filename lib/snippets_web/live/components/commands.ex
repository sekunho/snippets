defmodule SnippetsWeb.Components.CommandsModal do
  use Surface.Component

  def render(assigns) do
    ~H"""
    <div class="absolute w-full h-screen bg-black bg-opacity-50 flex items-center justify-center">
      <div class="w-1/4 bg-gruvbox-bg1 rounded-md p-4 space-y-6">
        <h3 class="text-gruvbox-fg text-xl">Commands</h3>

        <ul class="text-gruvbox-fg list-disc pl-4 space-y-4">
          <li :for={{ {cmd_str, info} <- commands() }}>
            <span class="font-mono bg-gruvbox-bg0_h px-2 py-1 rounded-md">{{ cmd_str }}</span>
            -
            {{ info }}
          </li>
        </ul>

        <button
          id="close-commands"
          type="button"
          phx-hook="FocusElement"
          :on-click="close-commands"
          class="bg-gruvbox-orange px-4 py-2 w-full rounded-md text-gruvbox-bg0_h text-sm font-mono font-medium hover:bg-opacity-80 focus:outline-none focus:ring focus:border-blue-300">
          Okay, got it.
        </button>
      </div>
    </div>
    """
  end

  defp commands do
    [
      {"save filename.txt", "Saves a snippet with the given filename."},
      {"commands", "Displays the list of available commands."}
    ]
  end
end
