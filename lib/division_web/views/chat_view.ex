defmodule DivisionWeb.ChatView do
  use DivisionWeb, :view

  alias Division.Accounts.User

  def addressed_message?(message, username) do
    cond do
      String.contains?(message, "@#{username}") -> "addressed-message"
      true -> ""
    end
  end

  def avatar(%User{avatar: nil} = user) do
    username = user.username |> String.first() |> String.upcase()
    content_tag(:div, username, class: "avatar")
  end

  def avatar(%User{avatar: avatar} = user) do
    Division.Avatar.url({avatar, user}, :thumb, signed: true)
    |> img_tag(class: "avatar")
  end
end
