defmodule Division.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Division.Accounts.User
  alias Division.Chats.Chat
  alias Division.Network.Node

  schema "messages" do
    field :content, :string
    belongs_to :chat, Chat
    belongs_to :user, User
    belongs_to :producer, Node
    belongs_to :consumer, Node

    timestamps()
  end

  @doc false
  def changeset(message, params) do
    message
    |> cast(params, [:chat_id, :content, :user_id, :producer_id, :consumer_id])
    |> validate_required([:content, :producer_id, :consumer_id])
  end
end
