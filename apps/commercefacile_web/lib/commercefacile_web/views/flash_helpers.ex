defmodule Commercefacile.Web.FlashHelpers do
    import Phoenix.Controller, only: [get_flash: 2]
    use Phoenix.HTML

    def flash?(conn) do
        if _any?(conn)  do
            content_tag :section, class: "section", style: "padding-top: 0;" do
                [flash?(conn, :error), flash?(conn, :info), flash?(conn, :success)]             
            end
        end
    end
    def flash?(conn, :error) do
        class = "is-danger"
        _flash?(conn, :error, class)
    end
    def flash?(conn, :info) do
        class = "is-info"
        _flash?(conn, :info, class)
    end
    def flash?(conn, :success) do
        class = "is-success"
        _flash?(conn, :success, class)
    end
    defp _flash?(conn, key, class) do
        content_tag :div, class: "notification has-text-centered " <> class do
            get_flash(conn, key)
        end
    end

    defp _any?(conn) do 
        _any?(conn, :error) || _any?(conn, :success) || _any?(conn, :info) 
    end
    defp _any?(conn, :success), do: if get_flash(conn, :success), do: true, else: false
    defp _any?(conn, :error), do: if get_flash(conn, :error), do: true, else: false
    defp _any?(conn, :info), do: if get_flash(conn, :info), do: true, else: false
end