defmodule Commercefacile.Image.Transformer.ImageMagick do
    @behaviour Commercefacile.Image.Transformer.Behaviour

    @default_watermark_dissolve 75
    @default_gravity "center"

    def transform(input, output, {:watermark, watermark}) do
        r = String.split("composite -dissolve #{@default_watermark_dissolve}% -gravity #{@default_gravity} #{watermark} #{input} #{output}")
        |> execute
        case r do
            {_, 0} -> {:ok, output}
            _ -> {:error, :watermark}
        end
    end

    def transform(input, output, {:resize, size}) do
        r = String.split("convert #{input} -resize #{size}x#{size} #{output}")
        |> execute
        case r do
            {_, 0} -> {:ok, output}
            _ -> {:error, :resize}
        end
    end

    defp execute([cmd | args]) do
        System.find_executable(cmd)
        |> System.cmd(args)
    end
end