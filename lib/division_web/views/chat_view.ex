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
  
  def date_time(%{inserted_at: inserted_at}) do
    native_datetime = DateTime.to_naive(DateTime.utc_now)
    native_date = NaiveDateTime.to_date(native_datetime)
    date_of_inserted_at = NaiveDateTime.to_date(inserted_at)
    
      case Date.compare(native_date, date_of_inserted_at) do
       :gt -> inserted_at
       :lt -> "Something went wrong"
       :eq -> NaiveDateTime.to_time(inserted_at)
       end
  end
  
end
