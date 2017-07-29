defmodule Commercefacile.Services.Generator.Mock do
    @behaviour Commercefacile.Services.Generator.Behaviour

    def generate_string(_), do: "string"
    
    def generate_digits(_), do: "123456"

    def generate_hashid(_), do: "kfjaldf"
end