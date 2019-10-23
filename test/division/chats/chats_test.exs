defmodule Division.ChatsTest do
  use Division.DataCase

  alias Division.Chats

  describe "chats" do
    alias Division.Network.Node

    @valid_attrs %{"name" => "some name"}
    @update_attrs %{"name" => "some updated name"}
    @invalid_attrs %{"name" => nil}

    def chat_fixture(attrs \\ %{}) do
      {:ok, chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_chat()

      chat
    end

    test "list_chats/0 returns all chats" do
      chat = chat_fixture()
      assert Chats.list_chats() == [chat]
    end

    test "get_chat_with_messages/1 returns the chat with given id" do
      chat = chat_fixture()
      loaded_chat = Chats.get_chat_with_messages(chat.id)
      assert loaded_chat.name == "some name"
      assert loaded_chat.inbox == []
    end

    test "create_chat/1 with valid data creates a chat" do
      assert {:ok, %Node{} = chat} = Chats.create_chat(@valid_attrs)
      assert chat.name == "some name"
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      assert {:ok, %Node{} = chat} = Chats.update_chat(chat, @update_attrs)
      assert chat.name == "some updated name"
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_chat(chat, @invalid_attrs)
      assert Chats.get_chat_with_messages(chat.id).name == "some name" # same name
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Chats.change_chat(chat)
    end
  end
end
