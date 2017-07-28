defmodule Commercefacile.Web.InputHelpers do
    use Phoenix.HTML

    def input(form, field, opts \\ []) do
        type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)
        input_opts = Keyword.drop(opts, [:using])
        {_, input_opts} = if form.errors[field] do 
            Keyword.get_and_update(input_opts, :class, fn c -> 
                {c, c <> " is-danger"} 
            end)
        else
            {nil, input_opts}
        end
        apply(Phoenix.HTML.Form, type, [form, field, input_opts])
    end

    def make_control(form, field, :text) do
        error_class = if form.errors[field], do: "is-danger", else: ""
        content_tag :p, class: "control" do
            text_input form, field, class: "input " <> error_class
        end
    end
    def make_control(form, field, :text, [{:icon, icon}]) do
        error_class = if form.errors[field], do: "is-danger", else: ""
        content_tag :p, class: "control has-icons-left" do
            input = text_input form, field, class: "input " <> error_class
            icon = make_icon icon
            [input, icon]
        end
    end

    def make_help(form, field, help) do
        if error = form.errors[field] do
            content_tag :p, class: "help is-danger" do
                Commercefacile.Web.ErrorHelpers.translate_error error
            end
        else
            content_tag :p, class: "help" do
                help
            end
        end
    end

    def make_help(form, field) do
        if error = form.errors[field] do
            content_tag :p, class: "help is-danger" do
                Commercefacile.Web.ErrorHelpers.translate_error error
            end
        else
            ""
        end
    end

    def make_icon(icon) do
        content_tag :span, class: "icon is-small" do
            content_tag :i, nil, class: icon
        end
    end
end