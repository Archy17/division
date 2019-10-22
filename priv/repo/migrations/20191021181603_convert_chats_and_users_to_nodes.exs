defmodule Division.Repo.Migrations.ConvertChatsAndUsersToNodes do
  use Ecto.Migration
  alias Division.Chats
  alias Division.Chats.Chat
  alias Division.Chats.Message
  alias Division.Accounts
  alias Division.Accounts.User
  alias Division.Repo
  alias Division.Network
  import Ecto.Query, warn: false

  def up do
    users_query = from u in User

    # create node for each user
    Enum.each(Repo.all(users_query), fn user ->
      case Network.create_node(%{name: user.username, type: "person"}) do
        {:ok, node} -> Accounts.update_user(user, %{node_id: node.id})
        _ -> IO.inspect("User #{user.name} node is not created")
      end
    end)

    msg_query = from m in Message, preload: [:user]
    chats_query = from c in Chat, preload: [messages: ^msg_query]

    # create node for each chat
    Enum.each(Repo.all(chats_query), fn chat ->
      case Network.create_node(%{name: chat.name, type: "chat"}) do
        {:ok, node} ->
          Enum.map(chat.messages, fn msg ->
            Chats.update_message(msg, %{producer_id: msg.user.node_id, consumer_id: node.id})
          end)
        _ -> IO.inspect("Chat #{chat.name} node is not created")
      end
    end)
  end

  def down do
    Ecto.Adapters.SQL.query!(Repo, "update users set node_id = null", [])
    Ecto.Adapters.SQL.query!(Repo, "update messages set producer_id = null", [])
    Ecto.Adapters.SQL.query!(Repo, "update messages set consumer_id = null", [])
    query =
      from n in Network.Node
    Repo.delete_all(query)
  end
end
