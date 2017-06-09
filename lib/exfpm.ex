defmodule Exfpm do

	alias Exfpm.Client.Request, as: Request
  
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
		{:ok, agent} = Exfpm.Client.start_link({{:local, "/run/php/php7.0-fpm.sock"}, 0})
		request = Request.new("/home/marc/Projects/exfpm/worker.php", "")
		{:reply, data} = GenServer.call(agent, {:request, request})

		IO.puts data
  end

  def connect do
    {:ok, pid} = :gen_tcp.connect('127.0.0.1', 9000, [])
  end

  def send(client, request = %Request{}) do
    #{:ok, packets} = Request.get_packets(request, params, body)
		#{:ok, data} = :gen_tcp.send(pid, packets)
		#{:ok, response} = Response.from_stream(packets)
  end
end
