defmodule Commercefacile.Image.Transformer.ImageMagick do
    @behaviour Commercefacile.Image.Transformer.Behaviour

    @default_watermark_dissolve 75
    @default_gravity "center"

    def transform(input, output, {:watermark, watermark}) do
        String.split("composite -dissolve #{@default_watermark_dissolve}% -gravity #{@default_gravity} #{watermark} #{input} #{output}")
        |> execute
    end

    def transform(input, output, {:resize, size}) do
        String.split("convert #{input} -resize #{size}x#{size} #{output}")
        |> execute
    end

    def execute([cmd | args]) do
        System.find_executable(cmd)
        |> System.cmd(args)
    end
end