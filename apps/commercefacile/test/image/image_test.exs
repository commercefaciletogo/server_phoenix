defmodule Commercefacile.ImageTest do
    use Commercefacile.DataCase

    alias Commercefacile.Image

    @output_path "/home/guru/Documents/projects/phoenix/commercefacile_umbrella/apps/commercefacile/store/output/ads"
    @input_path "/home/guru/Documents/projects/phoenix/commercefacile_umbrella/apps/commercefacile/store/input/ads"

    # @tag :skip
    test "new from upload" do
        upload = %{path: Path.expand("test/fixtures/test.jpg"), filename: "test.jpg"}
        result = Image.new!(:original, upload)
        assert {:ok, _reference, %Image{resized: true, version: :original, filename: filename} = image} = result
        assert Path.dirname(image.path) == @output_path
        refute File.exists? @input_path <> "/#{filename}"

        assert {:ok, %Image{path: path}} = Image.store(:temp, image) 
        assert path == "/ads/temp/#{filename}"
        refute File.exists? @output_path <> "/#{filename}"
        Commercefacile.Image.delete(:cloud, path)
    end

    # @tag :skip
    test "new from 'ads/temp' cloud" do
        path = "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"
        uuid = "0q6nXAUEVhESfmlUEEDZ2GhD5ON"
        scope = %{uuid: uuid}
        assert {:ok, _reference, %Image{resized: true, version: :original, filename: filename} = image} =
            Image.new!(:original, path, 1, scope: scope)
        assert Path.dirname(image.path) == @output_path
        refute File.exists? @input_path <> "/#{filename}"
        assert File.exists? @output_path <> "/#{filename}"

        assert {:ok, %Image{path: path}} = Image.store(:cloud, image) 
        assert path == "/ads/#{filename}"
        refute File.exists? @output_path <> "/#{filename}"

        Commercefacile.Image.delete(:cloud, path)
    end

    # @tag :skip
    test "new from 'ads' cloud -> original" do
        path = "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/0q6nXAUEVhESfmlUEEDZ2GhD5ON_1_original.jpeg"
        uuid = "0q6nXAUEVhESfmlUEEDZ2GhD5ON"
        scope = %{uuid: uuid}
        assert {:ok, _reference, %Image{public_url: ^path, path: p, resized: true, version: :original, filename: filename} = image} =
            Image.new!(:original, path, 1, scope: scope)

        assert ^p = "/ads/#{filename}"

        refute File.exists? @input_path <> "/#{filename}"
        refute File.exists? @output_path <> "/#{filename}"

        assert {:ok, %Image{path: path}} = Image.store(:cloud, image) 
        assert path == "/ads/#{filename}"
        refute File.exists? @output_path <> "/#{filename}"
    end

    test "new from 'ads' cloud -> big" do
        path = "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/0q6nXAUEVhESfmlUEEDZ2GhD5ON_1_original.jpeg"
        uuid = "0q6nXAUEVhESfmlUEEDZ2GhD5ON"
        scope = %{uuid: uuid}
        assert {:ok, _reference, %Image{path: p, resized: true, version: :big, filename: filename} = image} =
            Image.new!(:big, path, 1, scope: scope)

        {:ok, %Image{watermarked: true, path: current_path}} = Image.watermark(image, Image.get_watermark_path())

        path = "/ads/#{filename}"
        assert {:ok, %Image{path: ^path, public_url: url}} = Image.store(:cloud, image) 
        assert String.ends_with?(url, "_1_big.jpeg")
        refute File.exists? @output_path <> "/#{filename}"
        refute File.exists? @input_path <> "/#{filename}"
    end

    # @tag :skip
    test "new from 'ads' cloud -> small" do
        path = "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/0q6nXAUEVhESfmlUEEDZ2GhD5ON_1_original.jpeg"
        uuid = "0q6nXAUEVhESfmlUEEDZ2GhD5ON"
        scope = %{uuid: uuid}
        assert {:ok, _reference, %Image{public_url: url, path: p, resized: true, version: :small, filename: filename} = image} =
            Image.new!(:small, path, 1, scope: scope)

        {:ok, %Image{watermarked: true, path: current_path}} = Image.watermark(image, Image.get_watermark_path())

        path = "/ads/#{filename}"
        assert {:ok, %Image{path: ^path, public_url: url}} = Image.store(:cloud, image) 
        assert String.ends_with?(url, "_1_small.jpeg")
        refute File.exists? @output_path <> "/#{filename}"
        refute File.exists? @input_path <> "/#{filename}"
    end
    
end