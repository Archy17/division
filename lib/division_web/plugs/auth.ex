defmodule DivisionWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Division.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    Plug.Conn.get_session(conn, :current_user_id)
    conn = get_user_from_session(conn, {})

    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def get_user_from_session(conn, _) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    if user_id do
      current_user = Accounts.get_user!(user_id)
      conn |> assign(:current_user, current_user)
    else
      conn
    end
  end
end
