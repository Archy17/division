defmodule Division.Network.Node do
  use Ecto.Schema
  import Ecto.Changeset

  alias Division.Chats.Message

  schema "nodes" do
    field :name, :string
    field :type, :string

    has_many :inbox, Message, on_delete: :delete_all, foreign_key: :consumer_id
    has_many :sent, Message, on_delete: :delete_all, foreign_key: :producer_id

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
    # |> validate_length(:name, min: 9)
  end
end
