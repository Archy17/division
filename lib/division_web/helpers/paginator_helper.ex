defmodule DivisionWeb.Helpers.PaginatorHelper do
  @moduledoc """
  Renders the pagination with a previous button, the pages, and the next button.
  """

  use Phoenix.HTML

  def render(conn, data, class: class) do
    first = prev_button(conn, data)
    pages = page_buttons(conn, data)
    last = next_button(conn, data)

        IO.puts "-------data data data----------"
        IO.inspect (data)
        IO.puts "-------дальше после data -------"



    content_tag(:ul, [first, pages, last], class: class)
  end

  defp prev_button(conn, data) do
    page = data.current_page - 1
    disabled = data.current_page == 1
    params = build_params(conn, page)
        IO.puts "------Опять ПАРАМСЫ в хелпере-----------"
        IO.inspect (page)
        IO.puts "-------дальше появление совсем хз -------"

    content_tag(:li, disabled: disabled) do
      link to: "?#{params}", rel: "prev" do
        "<"
      end
    end
  end

  defp page_buttons(conn, data) do
    for page <- 1..data.total_pages do
      class = if data.current_page == page, do: "active"
      disabled = data.current_page == page
      params = build_params(conn, page)

        IO.puts "------Опять ПАРАМСЫ 222222222 в хелпере-----------"
        IO.inspect (page)
        IO.puts "-------дальше появление совсем хз -------"

      content_tag(:li, class: class, disabled: disabled) do
        link(page, to: "?#{params}")
      end
    end
  end

  defp next_button(conn, data) do
    page = data.current_page + 1
    disabled = data.current_page >= data.total_pages
    params = build_params(conn, page)

        IO.puts "------Опять ПАРАМСЫ 333333333 в хелпере-----------"
        IO.inspect (page)
        IO.puts "-------дальше появление совсем хз -------"


    content_tag(:li, disabled: disabled) do
      link to: "?#{params}", rel: "next" do
        ">"
      end
    end
  end

  defp build_params(conn, page) do

        IO.puts "------Опять ПАРАМСЫ В БИЛД ПАРМСАХ В ДЕПФ в хелпере-----------"
        IO.inspect (page)
        IO.puts "-------дальше появление совсем хз -------"
   
     
   case Map.equal?(conn.query_params, %{}) do
      true ->  conn.query_params |> Map.put(:page, page) |> URI.encode_query()
      false -> conn.query_params |> Map.delete("page") |> Map.put(:page, page) |> URI.encode_query()
   end

   # IO.puts "------Опять ПАРАМСЫ u_r_i u_r_i u_r_i u_r_i в хелпере-----------"

        #  IO.inspect (:page)
        #  IO.inspect (page)     u_r_i = 

        # IO.inspect (u_r_i)
        # IO.puts "-------дальше появление u_r_i u_r_i совсем хз -------"

  end
end