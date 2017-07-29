defmodule Commercefacile.Services.Generator do
    @behaviour Commercefacile.Services.Generator.Behaviour

    @hash_salt "XPEoIo/y8r5Tw2tcWqse6Fed2oDpWUGqo+IDd7L/WcDjWdXUN01f9mu/He476IIv"
    @hash_min_len 7

    def generate_string(0), do: {:error, :invalid_argument}
    def generate_string(number)
    when is_number(number)
    do
        
    end
    def generate_string(_), do: {:error, :invalid_argument}

    def generate_hashid(id)
    when is_number(id)
    do
        h = Hashids.new(salt: @hash_salt, min_len: @hash_min_len)
        Hashids.encode(h, id) |> String.downcase
    end
    def generate_hashid(_), do: {:error, :invalid_argument}

    def generate_digits(0), do: {:error, :invalid_argument}
    def generate_digits(number) 
    when is_number(number)
    do
        (_start(number).._end(number))
        |> Enum.random()
        |> Integer.to_string()
    end
    def generate_digits(_), do: {:error, :invalid_argument}

    defp _start(number) do
        (1..number - 1)
        |> Enum.reduce("1", fn(_, acc) -> acc <> "0" end)
        |> String.to_integer()
    end

    defp _end(number) do
        (1..number - 1)
        |> Enum.reduce("9", fn(_, acc) -> acc <> "9" end)
        |> String.to_integer()
    end
end