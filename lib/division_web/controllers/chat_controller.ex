defmodule DivisionWeb.ChatController do
  use DivisionWeb, :controller

  alias Division.Chats
  alias Division.Network.Node

  alias Phoenix.LiveView
  alias DivisionWeb.ChatLiveView

  def index(conn, _params) do
    chats = Chats.list_chats()
    render(conn, "index.html", chats: chats)
  end

  def new(conn, _params) do
    changeset = Chats.change_chat(%Node{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"node" => chat_params}) do
    case Chats.create_chat(chat_params) do
      {:ok, chat} ->
        conn
        |> put_flash(:info, "Chat created successfully.")
        |> redirect(to: Routes.chat_path(conn, :show, chat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    chat = Chats.get_chat_with_messages(id)

    LiveView.Controller.live_render(
      conn,
      ChatLiveView,
      session: %{chat: chat, current_user: conn.assigns.current_user}
    )
  end

   def edit(conn, %{"id" => id}) do
     chat = Chats.get_chat!(id)
     changeset = Chats.change_chat(chat)
     render(conn, "edit.html", node: chat, changeset: changeset)
   end

   def update(conn, %{"id" => id, "node" => chat_params}) do
     chat = Chats.get_chat!(id)

     case Chats.update_chat(chat, chat_params) do
       {:ok, chat} ->
         conn
         |> put_flash(:info, "Chat updated successfully.")
         |> redirect(to: Routes.chat_path(conn, :show, chat))

       {:error, %Ecto.Changeset{} = changeset} ->
         render(conn, "edit.html", node: chat, changeset: changeset)
     end
   end
end
