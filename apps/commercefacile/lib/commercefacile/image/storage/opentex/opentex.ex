defmodule Commercefacile.Image.Storage.Opentex do
    @behaviour Commercefacile.Image.Storage.Behaviour

    alias Commercefacile.Image.Storage.Opentex.Cloudfiles.Swift

    @container_name "commercefacile"

    def get(cloud_path) do
        resp = Swift.download_file(cloud_path, @container_name)
        case resp do
            {:ok, %{response: %{body: data}}} -> {:ok, data}
            {:error, _} -> :error
        end
    end

    def put(path, cloud_path) do
        resp = Swift.upload_file(path, cloud_path, @container_name)
        case resp do
            {:ok, _} -> :ok
            {:error, _} -> :error 
        end
    end

    def delete(cloud_path) do
        resp = Swift.delete_object(cloud_path, @container_name)
        case resp do
            {:ok, _} -> :ok
            {:error, _} -> :error 
        end
    end
end