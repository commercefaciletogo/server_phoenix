defmodule Commercefacile.Web.UploadController do
    use Commercefacile.Web, :controller
    
    alias Commercefacile.Image

    def upload(conn, %{"image" => image}) do
        with {:ok, _, %Image{} = image} <- Image.new!(:original, image),
            {:ok, %Image{public_url: url} = uploaded} <- Image.store(:temp, image)
        do
            conn
            |> add_ad_image(url)
            |> render("upload.json", data: %{filename: uploaded.filename, url: url})
        else
            _ -> 
                conn
                |> put_status(:gateway_timeout)
                |> render("error.json", code: 504)
        end
    end

    defp add_ad_image(conn, url) do
        case get_session(conn, :ad_images) do
            nil -> 
                conn = put_session(conn, :ad_images, [url])
                IO.inspect(get_session(conn, :ad_images))
                conn
            old when is_list(old) ->
                r_old = Enum.reverse(old)
                new = [url | r_old] |> Enum.reverse
                conn = put_session(conn, :ad_images, new)
                IO.inspect(get_session(conn, :ad_images))
                conn
        end
    end

    def delete(conn, %{"reference" => filename, "url" => url}) do
        case Image.delete(:cloud, filename) do
            :ok -> 
                conn
                |> delete_ad_image(url)
                |> render("delete.json")
            :error -> 
                conn
                |> put_status(:gateway_timeout)
                |> render("error.json", code: 504)
        end
    end

    defp delete_ad_image(conn, url) do
        case get_session(conn, :ad_images) do
            nil -> 
                IO.inspect(get_session(conn, :ad_images))
                conn
            old when is_list(old) ->
                new = Enum.reject(old, fn u -> u == url end)
                conn = delete_session(conn, :ad_images)
                    |> put_session(:ad_images, new)
                IO.inspect(get_session(conn, :ad_images))
                conn
        end
    end

    defp image_position(conn) do
        case get_session(conn, :ad_images) do
            nil -> 1
            [] -> 1
            images -> length(images) + 1 
        end
    end
end