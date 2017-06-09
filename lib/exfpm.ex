defmodule Exfpm do

  alias Exfpm.Client.Request, as: Request
  alias Exfpm.Client.Response, as: Response

  import Exfpm.Encoders.Packet
  import Exfpm.Encoders.Pairs

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
  
  @moduledoc """
  Documentation for Exfpm.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Exfpm.hello
      :world

  """
  def hello do
    :world
  end

  def connect do
    {:ok, pid} = :gen_tcp.connect('127.0.0.1', 9000, [])
  end

  def send(client, request = %Request{id: id}) do
    encode(
      @begin_request,
      <<0, @responder, 1, 0, 0, 0, 0, 0>>,
      id
    )

  end

  """
  # Keep alive bit always set to 1
		$requestPackets = $this->packetEncoder->encodePacket(
			self::BEGIN_REQUEST,
			chr( 0 ) . chr( self::RESPONDER ) . chr( 1 ) . str_repeat( chr( 0 ), 5 ),
			$this->id
		);
		$paramsRequest = $this->nameValuePairEncoder->encodePairs( $request->getParams() );
		if ( $paramsRequest )
		{
			$requestPackets .= $this->packetEncoder->encodePacket( self::PARAMS, $paramsRequest, $this->id );
		}
		$requestPackets .= $this->packetEncoder->encodePacket( self::PARAMS, '', $this->id );
		if ( $request->getContent() )
		{
			$requestPackets .= $this->packetEncoder->encodePacket( self::STDIN, $request->getContent(), $this->id );
		}
		$requestPackets .= $this->packetEncoder->encodePacket( self::STDIN, '', $this->id );
		return $requestPackets;
    """
end
