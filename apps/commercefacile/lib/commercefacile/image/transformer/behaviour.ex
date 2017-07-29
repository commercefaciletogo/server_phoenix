defmodule Commercefacile.Image.Transformer.Behaviour do
    @callback transform(input_path :: String.t, out_path :: String.t, {cmd :: atom, args :: list}) :: {:ok, out_path :: String.t} | {:error, reason :: String.t}
end