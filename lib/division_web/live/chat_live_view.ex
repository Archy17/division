defmodule DivisionWeb.ChatLiveView do
  use Phoenix.LiveView
  alias Division.Chats

  defp topic(chat_id), do: "chat:#{chat_id}"

  def render(assigns) do
    DivisionWeb.ChatView.render("show.html", assigns)
  end

  def mount(%{chat: chat, current_user: current_user}, socket) do
    ##chat_id = 666
   # DivisionWeb.Endpoint.subscribe(topic(chat.id))
   #         IO.puts "+++++++++Моунт++++++++"
   #         IO.inspect(topic(chat.id))
   #         IO.puts "+++++++++Моунт++++++++"
    {:ok,
     assign(socket,
       chat: chat,
       message: Chats.change_message(),
       current_user: current_user
     )}
  end

  def handle_info(%{event: "message", payload: state}, socket) do
           IO.puts "++++++++ИНФО++++++++"
    {:noreply, assign(socket, state)}
  end

  def handle_event("message", %{"message" => %{"content" => ""}}, socket) do
    IO.puts "--+++++-- Первый Эвент --+++++--"
    {:noreply, socket}
  end

  def handle_event("message", %{"message" => message_params}, socket) do
    {:ok, message} = Chats.create_message(message_params)
    IO.puts "++++Второй эвент ---  Запись сообщения в бд -- ++++++"
    chat = Chats.get_chat_with_messages(message.chat_id)
    DivisionWeb.Endpoint.broadcast_from(self(), topic(chat.id), "message", %{chat: chat})
    {:noreply, assign(socket, chat: chat, message: Chats.change_message())}
  end

  def handle_event("typing", _value, socket = %{assigns: %{}}) do
          IO.puts "--+++++ event typing -- ++++"
    {:noreply, socket}
  end

  def handle_event(
        "stop_typing",
        value,
        socket = %{assigns: %{message: message}}
      ) do
    message = Chats.change_message(message, %{content: value})
         IO.puts "---+++++_____stop_typing-------++++"
    {:noreply, assign(socket, message: message)}
  end
end
