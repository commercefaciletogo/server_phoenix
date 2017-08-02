defmodule Commercefacile.Image.Storage.Mock do
    @behaviour Commercefacile.Image.Storage.Behaviour

    @test_file Path.expand("test/fixtures/test.jpg")

    def get(path) do
        {:ok, File.read!(@test_file)}
    end
    def put(path, cloud_path) do
        :ok
    end
    def delete(path) do
        :ok
    end
    
end