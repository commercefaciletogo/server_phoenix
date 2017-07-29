defmodule Commercefacile.Image.Storage.Behaviour do
    @callback put(path :: String.t, cloud_path :: String.t) ::  :ok | :error
    @callback get(path :: String.t) ::  {:ok, file :: binary} | :error
    @callback delete(path :: String.t) ::  :ok | :error
end