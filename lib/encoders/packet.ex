defmodule Exfpm.Encoders.Packet do
    
    use Bitwise
    
    @version 1

    def encode(type, packet, id) do
        <<@version>> <>                                   # Version
        <<type>> <>                                       # type
        <<(id >>> 8) &&& 0xFF>> <>                        # requestId1
        <<id &&& 0xFF>> <>                                # requestId2
        <<(String.length(packet) >>> 8) &&& 0xFF>> <>     # contentLength1
        <<String.length(packet) &&& 0xFF>> <>             # contentLength2
        <<0, 0>> <>                                       # padding, reserved
        packet                                            # packet itself
    end

    @doc ~S"""
        iex> Exfpm.Encoders.Packet.header("akeisudhnasdu")
    """
    def header(<<version, type, id1, id2, length1, length2, padding, reserved, _::binary>>) do
        [
            version: version,
            type: type,
            requestId: (id1 <<< 8) + id2,
            contentLength: (length1 <<< 8) + length2,
            paddingLength: padding,
            reserved: reserved 
        ]
    end
end