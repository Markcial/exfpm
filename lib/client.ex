defmodule Exfpm.Client do
    use GenServer

    alias Exfpm.Client.Request, as: Request
    alias Exfpm.Client.Response, as: Response

    alias Exfpm.Encoders.Packet, as: Packet
    alias Exfpm.Encoders.Pairs, as: Pairs

    @begin_request      1
	@end_request        3
	@params             4
	@stdin              5
	@stdout             6
	@stderr             7
	@responder          1
	@request_complete   0
	@cant_mpx_conn      1
	@overloaded         2
	@unknown_role       3
	@header_len         8
	@req_state_written  1
	@req_state_ok       2
	@req_state_err      3
	@req_state_unknown  4
	@stream_select_usec 20000

    def start_link({address, port}) do
        {:ok, pid} = :gen_tcp.connect(address, port, active: false)
        GenServer.start_link(__MODULE__, %{:pid => pid})
    end

    def handle_call({:request, request = %Request{identifier: id}}, _from, state = %{:pid => pid}) do
        req = encode_request(request)
        
        :gen_tcp.send(pid, req)

        {:ok, data} = :gen_tcp.recv(pid, 0)

        IO.inspect Pairs.decode(to_string(data))
        #exit()
        
        #:gen_tcp.close(pid)

        #{:reply, Response.new(id, to_string(data), 10), state}
    end

    def encode_request(request = %Request{identifier: id, content: content}) do
        Packet.encode(@begin_request, <<0, @responder, 1>> <> String.duplicate(<<0>>, 5), id) <>
		Packet.encode(@params, Pairs.encode(Request.params(request)), id ) <>
		Packet.encode(@params, "", id) <>
		Packet.encode(@stdin, content, id) <>
		Packet.encode(@stdin, "", id)
    end
end
