defmodule SnippetsWeb.Utils.Mount do
  import Phoenix.LiveView
  alias Snippets.Accounts

  @spec assign_defaults(Phoenix.LiveView.Socket.t(), map) :: Phoenix.LiveView.Socket.t()
  def assign_defaults(socket, %{"user_token" => user_token}) do
    socket = assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(user_token) end)

    if socket.assigns.current_user do
      socket
    else
      redirect(socket, to: "/users/log_in")
    end
  end

  def assign_defaults(socket, _) do
    assign_new(socket, :current_user, fn -> nil end)
  end
end
