defmodule Division.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Division.Repo
  alias Division.Chats.Chat
  alias Division.Chats.Message
  alias Division.Network.Node


  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end


   @doc """
   Updates a message.

   ## Examples

       iex> update_message(message, %{field: new_value})
       {:ok, %Message{}}

       iex> update_message(message, %{field: bad_value})
       {:error, %Ecto.Changeset{}}

   """
   def update_message(%Message{} = message, attrs) do
     message
     |> Message.changeset(attrs)
     |> Repo.update()
   end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  # TODO: check arguments syntax
  def change_message(%Message{} = message \\ %Message{}) do
    Message.changeset(message, %{})
  end

  def change_message(changeset, changes) do
    Message.changeset(changeset, changes)
  end

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    query =
      from node in Node,
        where: node.type == "chat"

    Repo.all(query)
  end

  @doc false
  def get_chat!(id), do: Repo.get!(Node, id)

  @doc """
  Gets a single chat Node.

  Raises `Ecto.NoResultsError` if the chat Node does not exist.

  ## Examples

      iex> get_chat(123)
      %Node{}

      iex> get_chat(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_with_messages(chat_id) do
    msg_query =
      from msg in Message,
        limit: 2048,
        order_by: [desc: msg.inserted_at],
        preload: [:producer]

    query =
      from n in Node,
        where: n.id == ^chat_id,
        where: n.type == "chat",
        preload: [inbox: ^msg_query]

    Repo.one(query)
  end

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    %Node{}
    |> Node.changeset(Map.merge(attrs, %{"type" => "chat"}))
    |> Repo.insert()
  end

   @doc """
   Returns an `%Ecto.Changeset{}` for tracking chat changes.

   ## Examples

       iex> change_chat(chat)
       %Ecto.Changeset{source: %Chat{}}

   """
   def change_chat(%Node{} = chat) do
     Node.changeset(chat, %{"type" => "chat"})
   end

   @doc """
   Updates a chat.

   ## Examples

       iex> update_chat(chat, %{field: new_value})
       {:ok, %Chat{}}

       iex> update_chat(chat, %{field: bad_value})
       {:error, %Ecto.Changeset{}}

   """
   def update_chat(%Node{} = chat, attrs) do
     chat
     |> Node.changeset(attrs)
     |> Repo.update()
   end
end
