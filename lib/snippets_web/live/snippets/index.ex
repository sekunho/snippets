defmodule SnippetsWeb.SnippetsLive.Index do
  use Surface.LiveView
  import SnippetsWeb.Utils.Mount
  import SnippetsWeb.Utils.Cmd,
    only: [recognized_command?: 1, editor_height_class: 1, cmd_class: 1, parse_command: 1]

  alias SnippetsWeb.Router.Helpers, as: Routes
  alias Surface.Components.LivePatch
  alias SnippetsWeb.Components.{Item, CommandsModal}

  data cmd_buffer_open, :boolean, default: false
  data commands_modal_open, :boolean, default: false
  data is_cmd_valid, :boolean, default: nil
  data cmd_msg, :string, default: ""

  @impl true
  def mount(_, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <CommandsModal :if={{ @commands_modal_open }} />
    <div :on-window-keyup="cmd_buffer" class="editor">
      <div class="flex flex-1 {{ editor_height_class(@cmd_buffer_open) }}">
        <div class="snippets-list lg:block lg:w-2/6 xl:w-1/6 {{ editor_height_class(@cmd_buffer_open) }} h-full">
          <div class="flex flex-col items-center mt-8 space-y-4">
            <span class="text-center text-gruvbox-fg">Want to keep track of your snippets?</span>
            <LivePatch label="Sign in" to={{ Routes.user_session_path(@socket, :new) }} class="text-center bg-gruvbox-orange px-2 py-2 w-1/2 rounded-md text-gruvbox-bg0_h text-sm font-mono font-medium hover:bg-opacity-80 focus:outline-none focus:ring focus:border-blue-300" />
          </div>
          <Item :if={{ @current_user }} :for={{ _ <- 1..10 }} />
        </div>

        <div class="{{ editor_height_class(@cmd_buffer_open) }} z-10 w-full lg:w-4/6 xl:w-5/6 flex flex-col">
          <textarea
            id="editor-field"
            wrap="off"
            phx-hook="EditorField"
            placeholder="IO.puts \"Hello, world!\""/>
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
        |> update(:is_cmd_valid, fn _ -> nil end)

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
