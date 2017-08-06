defmodule Commercefacile.Type.EctoKsuid do
  @behaviour Ecto.Type
  # uses string/varchar as storage type.
  def type, do: :string

  def cast(ksuid) when is_binary(ksuid), do: {:ok, ksuid}
  def cast(_), do: :error

  @doc """
  Same as `cast/1` but raises `Ecto.CastError` on invalid arguments.
  """
  def cast!(value) do
    case cast(value) do
      {:ok, ksuid} -> ksuid
      :error -> raise Ecto.CastError, type: __MODULE__, value: value
    end
  end

  def load(ksuid), do: {:ok, ksuid}
  
  def dump(binary) when is_binary(binary), do: {:ok, binary}
  def dump(_), do: :error

  # Callback invoked by autogenerate fields - this is all that really matters
  # just passing around the binary otherwise.
  @doc false
  def autogenerate, do: Ksuid.generate()

end