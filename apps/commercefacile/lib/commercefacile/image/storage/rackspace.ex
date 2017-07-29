# defmodule Commercefacile.Image.Storage.Rackspace do
#     @behaviour Commercefacile.Image.Storage.Behaviour

#     @container_name "commercefacile"

#     def get(cloud_path) do
#         resp = Rackspace.Api.CloudFiles.Object.get(@container_name, cloud_path)
#         case resp do
#             %Rackspace.Api.CloudFiles.Object{data: data} -> {:ok, data}
#             _ -> :error
#         end
#     end

#     def put(path, cloud_path) do
#         binary = File.read!(path)
#         resp = Rackspace.Api.CloudFiles.Object.put(@container_name, cloud_path, binary)
#         case resp do
#             {:ok, _} -> :ok
#             _ -> :error 
#         end
#     end

#     def delete(cloud_path) do
#         resp = Rackspace.Api.CloudFiles.Object.delete(@container_name, cloud_path)
#         case resp do
#             {:ok, _} -> :ok
#             _ -> :error 
#         end
#     end
# end