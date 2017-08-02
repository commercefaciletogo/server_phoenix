defmodule Commercefacile.Image.Transformer.Mock do
    @behaviour Commercefacile.Image.Transformer.Behaviour

    def transform(_input_path, out_path, _tuple) do
        {:ok, out_path}
    end
    
end