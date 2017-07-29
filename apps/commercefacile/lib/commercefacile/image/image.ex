defmodule Commercefacile.Image do
    defstruct [:path, :filename, :version, :resized, :binary, :public_url, :main]

    @transformer Application.get_env(:commercefacile, Commercefacile.Image) |> Keyword.get(:transformer)
    @cloud_store Application.get_env(:commercefacile, Commercefacile.Image) |> Keyword.get(:cloud_store)

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
        with {:ok, s_path} <- _store_locally(version, reference, path, ext),
            {:ok, r_path} <- resize(version, s_path)
        do
            _remove(s_path)
            {:ok, reference, %Commercefacile.Image{path: r_path, filename: Path.basename(r_path), version: version, resized: true}}
        else
            # {:error, :enoent} -> raise("File Not Found Error") 
            # {:error, :resize} -> raise("File Resize Error") 
            {:error, reason} -> {:error, reason}
        end
    end
    def new!(version, filename, index, [{:scope, %{uuid: uuid}}]) do
        main? = index == 1
        reference = _get_reference(filename)
        ext = Path.extname filename
        with {:ok, s_path} <- _store_locally(version, reference, {index, uuid}, ext),
            {:ok, r_path} <- resize(version, s_path)
        do
            _remove(s_path)
            {:ok, reference, %Commercefacile.Image{main: main?, path: r_path, filename: Path.basename(r_path), version: version, resized: true}}
        else
            # {:error, reason}  -> raise("File Write Error")
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

    def resize(:small, path) do
        output = Path.basename(path) |> generate_path(:output)
        case @transformer.transform(path, output, {:resize, @small}) do
            {_, 0} -> {:ok, path}
            _ -> {:error, :resize}
        end
    end
    def resize(:big, path) do
        output = Path.basename(path) |> generate_path(:output)
        case @transformer.transform(path, output, {:resize, @big}) do
            {_, 0} -> {:ok, path}
            _ -> {:error, :resize}
        end
    end
    def resize(:original, path) do
        output = Path.basename(path) |> generate_path(:output)
        IO.inspect output
        case File.cp!(path, output) do
            :ok -> {:ok, output}
            _ -> {:error, :resize}
        end
    end

    def watermark(%Commercefacile.Image{resized: true, path: path, version: version}, watermark)
    when version != :original
    do
        @transformer.transform(path, path, {:watermark, watermark})
    end

    def store(:cloud, %Commercefacile.Image{path: path, filename: filename} = file) do
        cloud_path = generate_path(filename, :cloud)
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
        case @cloud_store.put(path, cloud_path) do
            :ok -> {:ok, %{file | path: cloud_path, public_url: url(:cloud, cloud_path)}}
            :error -> :error
        end
    end

    def get(:cloud, path, save_at) do
        IO.inspect {:donwload, path}
        case @cloud_store.get(path) do
            {:ok, binary} -> 
                File.write!(save_at, binary)
                {:ok, %Commercefacile.Image{path: save_at, filename: Path.basename(path), binary: binary}}
            :error -> :error
        end
    end

    def delete(:cloud, @rackspace_public_host <> path) do
        @cloud_store.delete(path)
    end
    def delete(:cloud, filename) do
        generate_temp_path(filename)
        |> @cloud_store.delete
    end

    def url(:cloud, @rackspace_public_host <> _ = url), do: url
    def url(:cloud, path) do
        Path.join(@rackspace_public_host, path)
    end

    defp _store_locally(version, reference, {index, ad_uuid}, ext) do
        path = generate_temp_filename(:original, reference, ext) |> generate_temp_path
        new_path = generate_filename(version, index, ad_uuid, ext)
            |> generate_path(:input)
        
        IO.inspect {:ref, reference}
        IO.inspect {:index, index}
        IO.inspect {:uuid, ad_uuid}
        IO.inspect {:old, path}
        IO.inspect {:new, new_path}

        with {:ok, image} <- @cloud_store.get(path),
            :ok <- File.write!(new_path, image)
        do
            {:ok, new_path}
        else 
            {:error, reason} -> {:error, reason}
        end
    end
    defp _store_locally(version, reference, path, ext) do
        new_path = generate_temp_filename(version, reference, ext)
            |> generate_path(:input)
        
        IO.inspect {:old, path}
        IO.inspect {:new, new_path}

        with true <- File.exists?(path),
            :ok <- File.cp!(path, new_path)
        do
            {:ok, new_path}
        else
            false -> {:error, :enoent}
            {:error, reason} -> {:error, reason}
        end
    end

    defp _remove(path) do
        if(File.exists? path) do
            File.rm path
        end
    end

    def generate_path(filename, :cloud) do
        "ads/#{filename}"
    end
    def generate_path(filename, :temp) do
        "ads/temp/#{filename}"
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
        "ads/temp/#{filename}"
    end

    def generate_temp_filename(:small, reference, ext) do
        "#{reference}_small#{ext}"
    end
    def generate_temp_filename(:original, reference, ext) do
        "#{reference}_original#{ext}"
    end
end