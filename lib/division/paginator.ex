defmodule Division.Paginator do
  @moduledoc """
  Paginate your Ecto queries.

  Instead of using: `Repo.all(query)`, you can use: `Paginator.page(query)`.
  To change the page you can pass the page number as the second argument.

  ## Examples

      iex> Paginator.paginate(query, 1)
      [%Item{id: 1}, %Item{id: 2}, %Item{id: 3}, %Item{id: 4}, %Item{id: 5}]

      iex> Paginator.paginate(query, 2)
      [%Item{id: 6}, %Item{id: 7}, %Item{id: 8}, %Item{id: 9}, %Item{id: 10}]

  """

  import Ecto.Query

  alias Division.Repo
  alias Division.Chats.Message
  alias Division.Chats.Chat

  @results_per_page 4

  def paginate(chat_id, page) when is_nil(page) do
    paginate(chat_id, 1)
  end

  #def paginate(chat_id, page) when page == 1 do
  #  paginate(chat_id, 1)
  #end

  def paginate(chat_id, page) when is_binary(page) do
    paginate(chat_id, String.to_integer(page))
  end

  def paginate(chat_id, page) do
    results = execute_query(chat_id, page)
    total_results = count_total_results(chat_id)
    total_pages = count_total_pages(total_results)

    %{
      current_page: page,
      results_per_page: @results_per_page,
      total_pages: total_pages,
      total_results: total_results,
      list: results
    }


  end

  defp execute_query(chat_id, page) do

     msg_query =
        from msg in Message,
        limit: (^@results_per_page) ,
        offset: ((^page - 1) * ^@results_per_page),
        order_by: [asc: msg.inserted_at],
        preload: [:user]

        query =
        from c in Chat,
        where: c.id == ^chat_id,
        preload: [messages: ^msg_query]

    Repo.one(query)



    #query
    #|> limit(^@results_per_page)
    #|> offset((^page - 1) * ^@results_per_page)
    #|> Repo.all()
  end

  defp count_total_results(chat_id) do
    query = from m in Message, where: (m.chat_id == ^chat_id), select: m


      Repo.aggregate(query, :count, :chat_id)
  end

  defp count_total_pages(total_results) do
    total_pages = total_results / @results_per_page |> ceil

    if total_pages > 1, do: total_pages, else: 1
  end
end
