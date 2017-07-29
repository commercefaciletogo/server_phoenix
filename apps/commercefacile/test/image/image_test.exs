defmodule Commercefacile.ImageTest do
    use Commercefacile.DataCase

    alias Commercefacile.Image

    @output_path "/home/guru/Documents/projects/phoenix/commercefacile_umbrella/apps/commercefacile/store/output/ads"
    @input_path "/home/guru/Documents/projects/phoenix/commercefacile_umbrella/apps/commercefacile/store/input/ads"

    @tag :skip
    test "new from upload" do
        upload = %{path: Path.expand("test/fixtures/test.jpg"), filename: "test.jpg"}
        result = Image.new!(:original, upload)
        assert {:ok, _reference, %Image{resized: true, version: :original, filename: filename} = image} = result
        assert Path.dirname(image.path) == @output_path
        refute File.exists? @input_path <> "/#{filename}"

        assert {:ok, %Image{path: path}} = Image.store(:temp, image) 
        assert path == "ads/temp/#{filename}"
        refute File.exists? @output_path <> "/#{filename}"
    end

    @tag :skip
    test "new from cloud" do
        path = "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com/ads/temp/0q6nXAUEVhESfmlUEEDZ2GhD5ON_original.jpeg"
        uuid = Ksuid.generate()
        scope = %{uuid: uuid}
        assert {:ok, _reference, %Image{resized: true, version: :original, filename: filename} = image} =
            Image.new!(:original, path, 1, scope: scope)
        assert Path.dirname(image.path) == @output_path
        refute File.exists? @input_path <> "/#{filename}"
        assert File.exists? @output_path <> "/#{filename}"

        assert {:ok, %Image{path: path}} = Image.store(:cloud, image) 
        assert path == "ads/#{filename}"
        refute File.exists? @output_path <> "/#{filename}"
    end


    # describe "new from reference as" do

    #     test "small" do
    #         filename = "0q4BZImrhkQqQllQ8sR2Giv0Sou_original.jpg"
    #         result = Image.new!(:small, filename, 1, scope: %{uuid: "0q47sX15QB1AUiVKuKjp8XkBuVo"})
    #         assert {:ok, _reference, %Image{resized: true, version: :small, filename: filename} = image} = result
    #         assert filename == "0q47sX15QB1AUiVKuKjp8XkBuVo_1_small.jpg"
    #         assert Path.dirname(image.path) == @output_path 
    #         refute File.exists? @input_path <> "/#{filename}"
    #     end
    # end
    
end