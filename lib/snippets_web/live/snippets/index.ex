defmodule SnippetsWeb.SnippetsLive.Index do
  use Surface.LiveView

  # Components
  alias Surface.Components.LivePatch
  alias SnippetsWeb.Components.{Item, CommandsModal}

  # Utilities
  import SnippetsWeb.Utils.Mount

  import SnippetsWeb.Utils.Cmd,
    only: [recognized_command?: 1, editor_height_class: 1, cmd_class: 1, parse_command: 1]

  alias SnippetsWeb.Router.Helpers, as: Routes
  alias SnippetsWeb.Utils.Editor

  data is_airline_open, :boolean, default: true

  @doc "Dictates which mode the editor will be in."
  data mode, :atom, default: Editor.normal()
  data is_cmd_buffer_open, :boolean, default: false
  data commands_modal_open, :boolean, default: false
  data is_cmd_valid, :boolean, default: nil
  data cmd_msg, :string, default: ""

  data snippet, :string,
    default: """
    @import url(https://fonts.googleapis.com/css?family=Questrial);
    @import url(https://fonts.googleapis.com/css?family=Arvo);

    @font-face {
      src: url(https://lea.verou.me/logo.otf);
      font-family: 'LeaVerou';
    }

    /*
    Shared styles
    */

    section h1,
    #features li strong,
    header h2,
    footer p {
      font: 100% Rockwell, Arvo, serif;
    }

    /*
    Styles
    */

    * {
      margin: 0;
      padding: 0;
    }

    body {
      font: 100%/1.5 Questrial, sans-serif;
      tab-size: 4;
      hyphens: auto;
    }

    a {
      color: inherit;
    }

    section h1 {
      font-size: 250%;
    }

      section section h1 {
        font-size: 150%;
      }

      section h1 code {
        font-style: normal;
      }

      section h1 > a,
      section h2[id] > a {
        text-decoration: none;
      }

      section h1 > a:before,
      section h2[id] > a:before {
        content: '§';
        position: absolute;
        padding: 0 .2em;
        margin-left: -1em;
        border-radius: .2em;
        color: silver;
        text-shadow: 0 1px white;
      }

      section h1 > a:hover:before,
      section h2[id] > a:hover:before {
        color: black;
        background: #f1ad26;
      }

    p {
      margin: 1em 0;
    }

    section h1,
    h2,
    h3 {
      margin: 1em 0 .3em;
    }
    """

  @impl true
  def mount(_, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <CommandsModal :if={{ @commands_modal_open }} />
    <div :on-window-keydown="process_key" class="editor">
      <div class="flex flex-1 {{ editor_height_class(@is_airline_open) }}">
        <div class="snippets-list lg:block lg:w-2/6 xl:w-1/6 {{ editor_height_class(@is_airline_open) }} h-full">
          <div class="flex flex-col items-center mt-8 space-y-4 px-4">
            <span class="text-center text-gruvbox-fg">Want to keep track of your snippets?</span>
            <LivePatch label="Sign in" to={{ Routes.user_session_path(@socket, :new) }} class="text-center bg-gruvbox-orange px-2 py-2 w-1/2 rounded-md text-gruvbox-bg0_h text-sm font-mono font-medium hover:bg-opacity-80 focus:outline-none focus:ring focus:border-blue-300" />
          </div>
          <Item :if={{ @current_user }} :for={{ _ <- 1..10 }} />
        </div>

        <div id="editor" phx-hook="HighlightCode" class="{{ editor_height_class(@is_airline_open) }} z-10 w-full lg:w-4/6 xl:w-5/6 flex flex-col">
          <textarea
            :if={{ @mode == Editor.insert() }}
            id="editor-field"
            wrap="off"
            phx-hook="EditorField"
            placeholder="IO.puts \"Hello, world!\"">{{ @snippet }}</textarea>

            <pre id="code-content" :if={{ @mode == Editor.normal() }} class="{{ editor_height_class(@is_airline_open) }} overflow-y-auto"><code class="language-css">{{ @snippet }}</code></pre>
        </div>
      </div>

      <div class="airline">
        <div :if={{ !@is_cmd_buffer_open }} class="status-bar flex">
          <span class="bg-gruvbox-gray1 text-lg z-10 rounded-r-full pl-2 pr-4 text-gruvbox-bg">
            {{ Editor.display_mode(@mode) }}
          </span>
          <span class="w-6 rounded-r-full bg-gruvbox-bg3 -ml-3"></span>
        </div>

        <form
        :if={{ @is_cmd_buffer_open }}
        :on-change="recognize_cmd"
        :on-submit="execute_cmd"
        class="cmd-buffer flex">
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
  def handle_event("process_key", %{"key" => key}, socket) do
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
        with false <- socket.assigns.is_cmd_buffer_open,
             :insert <- socket.assigns.mode do
          assign(socket, mode: Editor.normal())
        else
          true ->
            assign(socket, is_cmd_buffer_open: false)

          :normal -> socket
        end

      ":" ->
        if socket.assigns.mode == Editor.normal() do
          assign(socket, is_cmd_buffer_open: true)
        else
          socket
        end

      "i" ->
        if socket.assigns.mode == Editor.normal() do
          assign(socket, mode: Editor.insert())
        else
          socket
        end

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
