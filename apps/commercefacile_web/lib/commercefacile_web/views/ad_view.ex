defmodule Commercefacile.Web.AdView do
    use Commercefacile.Web, :view

    def render("title.create.html", _assings) do
        ~E(<title>Commercefacile.com | Deposer une annonce</title>)
    end

    def render("title.index.html", _assings) do
        ~E(<title>Commercefacile.com | Toutes annonces</title>)
    end

    def render("title.show.html", %{ad: ad}) do
        ~E(<title>Commercefacile.com | <%= ad.title %></title>)
    end

    def render("title.edit.html", %{ad: ad}) do
        ~E(<title>Commercefacile.com | Modifier <%= ad.title %></title>)
    end

    def render("share-meta.show.html", %{conn: conn, ad: %{uuid: uuid, title: title, description: description, images: [first|_], }}) do
        description = Curtail.truncate(description, length: 300)
        url = ad_path(conn, :show, uuid)
        ~E"""
        <meta itemprop="name"               content="Commercefacile.com | <%= title %>">
        <meta itemprop="description"        content="<%= description %>">
        <meta itemprop="image"              content="<%= first %>">

        <meta property="og:url"             content="<%= url %>">
        <meta property="og:type"            content="website" />
        <meta property="og:title"           content="Commercefacile.com | <%= title %>" />
        <meta property="og:description"     content="<%= description %>" />
        <meta property="og:image"           content="<%= first %>">
        
        <meta name="twitter:card"           content="summary_large_image">
        <meta name="twitter:url"            content="<%= url %>">
        <meta name="twitter:site"           content="@commercefacile">
        <meta name="twitter:creator"        content="Commercefacile.com">
        <meta name="twitter:title"          content="Commercefacile.com | <%= title %>">
        <meta name="twitter:description"    content="<%= description %>">
        <meta name="twitter:image"          content="<%= first %>">
        """
    end

    def rejected?(%{assigns: assigns}, field) do
        unless assigns["edit_mode"] do
            ""
        else
            if field in assigns["rejected_fields"] do
                " rejected "
            else
                ""
            end
        end
    end
end