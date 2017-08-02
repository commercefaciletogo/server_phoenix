defmodule Commercefacile.Image do
    defstruct [:path, :filename, :version, :resized, :binary, :public_url, :main, :watermarked]

    @transformer Application.get_env(:commercefacile, Commercefacile.Image) |> Keyword.get(:transformer)
    @store Application.get_env(:commercefacile, Commercefacile.Image) |> Keyword.get(:store)

    @local_input_storage Path.expand("store/input")
    @local_output_storage Path.expand("store/output")
    @watermark_path Path.expand("store/watermark.png")
    @rackspace_container "commercefacile"
    @rackspace_public_host "https://b86068563707f1548c7c-cc73bb3144250bf95e4a0690bc25f5d2.ssl.cf5.rackcdn.com"

    @small 100
    @big 500

    def new!(version, %{path: path, filename: filename}) do
        reference = Ksuid.generate()
        ext = Path.extname(filename)
        new_path = generate_temp_filename(version, reference, ext) |> generate_path(:input)

        with :ok <- File.cp!(path, new_path),
            {:ok, r_path} <- resize(version, new_path)
        do
            _remove(new_path)
            {:ok, 
                reference, %Commercefacile.Image{
                    public_url: nil, path: r_path, filename: Path.basename(r_path), version: version, resized: true
                }
            }
        else
            # {:error, :enoent} -> raise("File Not Found Error") 
            # {:error, :resize} -> raise("File Resize Error") 
            {:error, reason} -> {:error, reason}
        end
    end
    def new!(version, @rackspace_public_host <> "/ads/temp/" <> _ = url, index, [{:scope, %{uuid: uuid}}]) do
        main? = index == 1
        reference = _get_reference(url)
        ext = Path.extname(url)
        %{path: cloud_path} = URI.parse(url)
        local_path = generate_filename(version, index, uuid, ext) |> generate_path(:input)

        with {:ok, s_path} <- store_locally(from: cloud_path, to: local_path),
            {:ok, r_path} <- resize(version, s_path)
        do
            _remove(s_path)
            {:ok, 
                reference, %Commercefacile.Image{
                    public_url: nil, main: main?, path: r_path, filename: Path.basename(r_path), version: version, resized: true
                }
            }
        else
            # {:error, reason}  -> raise("File Write Error")
            {:error, reason} -> {:error, reason}
        end
    end
    def new!(version, @rackspace_public_host <> "/ads/" <> _filename = url, index, [{:scope, %{uuid: uuid}}]) do
        main? = index == 1
        reference = _get_reference(url)
        filename = generate_filename(version, index, uuid, Path.extname(url))

        {:ok, resized_path} = 
            if version == :original do
                resize(:original, url)
            else
                %{path: cloud_path} = URI.parse(url)
                local_path = generate_path(filename, :input)
                {:ok, s_path} = store_locally(from: cloud_path, to: local_path)
                resize(version, s_path)
            end

        public_url = if version == :original, do: url, else: nil 

        {:ok, 
            reference, %Commercefacile.Image{
                public_url: public_url, main: main?, path: resized_path, filename: filename, version: version, resized: true
            }
        }
    end

    defp store_locally([{:from, cloud_path}, {:to, local_path}]) do
        with {:ok, image} <- @store.get(cloud_path),
            :ok <- File.write!(local_path, image)
        do
            {:ok, local_path}
        else 
            {:error, reason} -> {:error, reason}
        end
    end

    def _get_reference("http" <> _ = path) do
        [reference | _] = Path.basename(path)
            |> String.split("_")
        reference
    end
    def _get_reference(name) do
        [reference | _] = String.split name, "_"
        reference
    end


    def resize(:original, @rackspace_public_host <> _ = url) do
        %{path: path} = URI.parse(url)
        IO.inspect {:resize, :original, url}
        {:ok, path}
    end
    def resize(version, path) do
        case _do_resize(version, path) do
            {:ok, output_path} ->
                _remove(path)
                {:ok, output_path}
            {:error, :resize} -> {:error, :resize}
        end
    end

    defp _do_resize(:small, path) do
        output = Path.basename(path) |> generate_path(:output)
        case @transformer.transform(path, output, {:resize, @small}) do
            {:ok, _path} -> {:ok, output}
            _ -> {:error, :resize}
        end
    end
    defp _do_resize(:big, path) do
        output = Path.basename(path) |> generate_path(:output)
        case @transformer.transform(path, output, {:resize, @big}) do
            {:ok, _path} -> {:ok, output}
            _ -> {:error, :resize}
        end
    end
    defp _do_resize(:original, path) do
        output = Path.basename(path) |> generate_path(:output)
        IO.inspect output
        case File.cp!(path, output) do
            :ok -> {:ok, output}
            _ -> {:error, :resize}
        end
    end

    def watermark(%Commercefacile.Image{watermarked: nil, resized: true, path: path, version: version} = image, watermark)
    when version != :original
    do
        case @transformer.transform(path, path, {:watermark, watermark}) do
            {:ok, _path} -> {:ok, %{image | watermarked: true}}
            {:error, reason} -> {:error, reason}
        end
    end

    def get_watermark_path(), do: @watermark_path

    def store(:cloud, %Commercefacile.Image{version: :original, public_url: @rackspace_public_host <> "/ads" <> _} = image) do
        {:ok, image}
    end
    def store(:cloud, %Commercefacile.Image{public_url: nil, path: path, filename: filename} = file) do
        cloud_path = generate_path(filename, :cloud)
        {:storing, cloud_path}
        case do_store(path, cloud_path, file) do
            {:ok, file} -> 
                _remove(path)
                {:ok, file}
            _ -> 
                _remove(path)
                :error
        end
    end
    def store(:temp, %Commercefacile.Image{path: path, filename: filename} = file) do
        IO.inspect {:temp_store, path}
        cloud_path = generate_path(filename, :temp)
        case do_store(path, cloud_path, file) do
            {:ok, file} -> 
                _remove(path)
                {:ok, file}
            _ -> 
                _remove(path)
                :error
        end
    end

    defp do_store(path, cloud_path, %Commercefacile.Image{} = file) do
        case @store.put(path, cloud_path) do
            :ok -> {:ok, %{file | path: cloud_path, public_url: url(:cloud, cloud_path)}}
            :error -> :error
        end
    end

    def get(:cloud, path, save_at) do
        IO.inspect {:donwload, path}
        case @store.get(path) do
            {:ok, binary} -> 
                File.write!(save_at, binary)
                {:ok, %Commercefacile.Image{path: save_at, filename: Path.basename(path), binary: binary}}
            :error -> :error
        end
    end

    def delete(:cloud, @rackspace_public_host <> path = url) do
        IO.inspect {:deleting, url}
        @store.delete(path)
    end
    def delete(:cloud, filename) do
        IO.inspect {:deleting, filename}
        generate_temp_path(filename)
        |> @store.delete
    end

    def url(:cloud, @rackspace_public_host <> _ = url), do: url
    def url(:cloud, path) do
        Path.join(@rackspace_public_host, path)
    end

    defp _remove(path) do
        if(File.exists? path) do
            File.rm path
        end
    end

    def generate_path(filename, :cloud) do
        "/ads/#{filename}"
    end
    def generate_path(filename, :temp) do
        "/ads/temp/#{filename}"
    end
    def generate_path(filename, :input) do
        "#{@local_input_storage}/ads/#{filename}"
    end
    def generate_path(filename, :output) do
        "#{@local_output_storage}/ads/#{filename}"
    end

    def generate_filename(:small, index, uuid, ext) do
        "#{uuid}_#{index}_small#{ext}"
    end
    def generate_filename(:big, index, uuid, ext) do
        "#{uuid}_#{index}_big#{ext}"
    end
    def generate_filename(:original, index, uuid, ext) do
        "#{uuid}_#{index}_original#{ext}"
    end

    def generate_temp_path(filename) do
        "/ads/temp/#{filename}"
    end

    def generate_temp_filename(:small, reference, ext) do
        "#{reference}_small#{ext}"
    end
    def generate_temp_filename(:original, reference, ext) do
        "#{reference}_original#{ext}"
    end
end