defmodule Commercefacile.Web.Helpers.Number do
    def number_with_delimiter(i, d \\ ".") 
    def number_with_delimiter(i, d) 
    when is_binary(i), do: number_with_delimiter String.to_integer(i, d)
    def number_with_delimiter(i, d) 
    when is_integer(i) 
    do
        i
        |> Integer.to_char_list
        |> Enum.reverse
        |> Enum.chunk(3, 3, [])
        |> Enum.join(d)
        |> String.reverse
    end
end