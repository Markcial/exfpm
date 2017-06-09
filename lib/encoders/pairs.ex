defmodule Exfpm.Encoders.Pairs do

    use Bitwise

    def decode(_, pairs \\ [])
    def decode(<<>>, pairs) do
        pairs
    end

    def decode(data, pairs) do
        case pair_length!(data) do
            {:ok, name_size, value_size, data1} -> 
                case String.length(data1) >= name_size + value_size do
                    true -> 
                        {name, data2} = String.split_at(data1, name_size)
                        {value, data3} = String.split_at(data2, value_size)
                        decode(data3, pairs ++ [{name, value}])
                    false -> IO.puts "error"
                end
        end
    end

    def pair_length!(data) do
        case packet_length(data) do
            {:error, reason1} -> raise reason1
            {:ok, name_size, data1} -> case packet_length(data1) do
                {:error, reason2} -> raise reason2
                {:ok, value_size, data2} -> {:ok, name_size, value_size, data2}
            end
        end
    end

    def packet_length(<<size, data::binary>>) when size < 128 do
        {:ok, size, data}
    end

    def packet_length(<<size,a1,a2,a3, data::binary>>) do
        {:ok, size &&& (0x7F <<< 24) ||| a1 <<< 16 ||| a2 <<< 8 ||| a3, data}
    end

    def packet_length(data) do
        {:error, :"Invalid packet length", data}
    end

    def encode(term) when is_binary(term) and byte_size(term) > 128 do
        <<String.length(term) >>> 24 ||| 0x80>> <>
        <<String.length(term) >>> 16 &&& 0xFF>> <>
        <<String.length(term) >>> 8 &&& 0xFF>> <>
        <<String.length(term) &&& 0xFF>>
    end

    @doc ~S"""
        iex> Exfpm.Encoders.Pairs.encode(:foo)
        <<3>>
        iex> Exfpm.Encoders.Pairs.encode(:foo)
        <<3>>
    """
    def encode(term) when is_binary(term) and byte_size(term) < 128 do
        <<String.length(term)>>
    end

    @doc ~S"""
        iex> Exfpm.Encoders.Pairs.encode(:foo)
        <<3>>
        iex> Exfpm.Encoders.Pairs.encode(:a_larger_atom)
        <<13>>
    """
    def encode(term) when is_atom(term), do: encode(Atom.to_string(term))
    def encode(term) when is_number(term), do: encode(to_string(term))

    @doc ~S"""
        iex> Exfpm.Encoders.Pairs.encode({:foo, "sample"})
        <<3, 6, 102, 111, 111, 115, 97, 109, 112, 108, 101>>
    """
    def encode({name, value}) do
        encode(name) <> encode(value) <> to_string(name) <> to_string(value)
    end

    @doc ~S"""
        iex> Exfpm.Encoders.Pairs.encode([foo: "sample", bar: "eggs"])
        [<<3, 6, 102, 111, 111, 115, 97, 109, 112, 108, 101>>,
            <<3, 4, 98, 97, 114, 101, 103, 103, 115>>]
    """
    def encode([{name, value}|t]) do
        encode({name, value}) <> encode(t)
    end

    def encode(pairs) when is_map(pairs), do: encode(Map.to_list(pairs))

    def encode([]) do
        ""
    end
end
