defmodule SnippetsWeb.SnippetsLive.Index do
  use Surface.LiveView

  import SnippetsWeb.CmdUtil,
    only: [recognized_command?: 1, editor_height_class: 1, cmd_class: 1, parse_command: 1]

  alias SnippetsWeb.Components.{Item, Commands}

  data cmd_buffer_open, :boolean, default: false
  data commands_modal_open, :boolean, default: false
  data is_cmd_valid, :boolean, default: nil
  data cmd_msg, :string, default: ""

  @impl true
  def render(assigns) do
    ~H"""
    <Commands :if={{ @commands_modal_open }} />
    <div :on-window-keyup="cmd_buffer" class="editor">
      <div class="flex flex-1 {{ editor_height_class(@cmd_buffer_open) }}">
        <div class="snippets-list {{ editor_height_class(@cmd_buffer_open) }} h-full">
          <Item :for={{ _ <- 1..500 }} />
        </div>
        <div class="{{ editor_height_class(@cmd_buffer_open) }} w-full lg:w-5/6 flex flex-col">
          <textarea id="editor-field" phx-hook="EditorField" placeholder="IO.puts \"Hello, world!\"" class="h-full w-full outline-none px-2 bg-transparent resize-none placeholder-gruvbox-bg3 flex-1"/>
        </div>
      </div>

      <form
        :if={{ @cmd_buffer_open }}
        :on-change="recognize_cmd"
        :on-submit="execute_cmd"
        class="cmd-buffer">
        <span class="text-gruvbox-orange">:</span>
        <input
          id="cmd-buffer"
          name="cmd"
          phx-hook="CmdBuffer"
          phx-debounce="200"
          type="text"
          class="{{ cmd_class(@is_cmd_valid) }} font-medium flex-1" />
          <span :if={{ @cmd_msg }} class="pl-2 text-gruvbox-red">
            {{ @cmd_msg }}
          </span>
      </form>
    </div>
    """
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("close-commands", _, socket) do
    {:noreply, update(socket, :commands_modal_open, fn _ -> false end)}
  end

  ## EDITOR RELATED

  @impl true
  def handle_event("cmd_buffer", %{"key" => key}, socket) do
    {:noreply, process_key(socket, key)}
  end

  @impl true
  def handle_event("recognize_cmd", %{"cmd" => cmd}, socket) do
    socket =
      case recognized_command?(cmd) do
        true ->
          socket
          |> assign(is_cmd_valid: true)
          |> update(:cmd_msg, fn _ -> "" end)

        {false, error_msg} ->
          socket
          |> assign(is_cmd_valid: false)
          |> assign(cmd_msg: error_msg)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("execute_cmd", %{"cmd" => cmd}, socket) do
    {:noreply, execute_command(socket, cmd)}
  end

  defp process_key(socket, key) do
    case key do
      "Escape" ->
        socket
        |> update(:cmd_buffer_open, fn c -> !c end)
        |> update(:cmd_msg, fn _ -> "" end)

      _ ->
        socket
    end
  end

  defp execute_command(socket, cmd_str) do
    cmd_str
    |> parse_command()
    |> case do
      ["commands"] ->
        socket
        |> update(:commands_modal_open, fn _ -> true end)
        |> update(:cmd_buffer_open, fn _ -> false end)

      _ ->
        socket
    end
  end
end
