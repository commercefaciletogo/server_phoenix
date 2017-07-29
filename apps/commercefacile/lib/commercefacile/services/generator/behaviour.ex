defmodule Commercefacile.Services.Generator.Behaviour do
    @callback generate_string(number :: integer) :: String.t | {:error, reason :: atom}
    @callback generate_digits(number :: integer) :: String.t | {:error, reason :: atom}
    @callback generate_hashid(id :: integer) :: String.t | {:error, reason :: atom}
end