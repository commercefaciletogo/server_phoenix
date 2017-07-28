defmodule Commercefacile.Web.UploadView do
    use Commercefacile.Web, :view

    def render("upload.json", %{data: data}) do
        %{status: "ok", code: 200, data: data}
    end

    def render("delete.json", _) do
        %{status: "ok", code: 200}
    end

    def render("error.json", %{code: code}) do
        %{status: "Internal Error", code: code}
    end
end