defmodule Exfpm.Client.Request do

    @interface 'FastCGI/1.0'
    @http_1_0 'HTTP/1.0'
	@http_1_1 'HTTP/1.1'

    defstruct [
        gatewayInterface: @interface,
        scriptFilename: nil,
        serverSoftware: 'ExFPM/fcgi-client',
        remoteAddress: '192.168.0.1', # TODO detect hostname with tcp_gen
        remotePort: 9985,
        serverAddress: '127.0.0.1',
        serverPort: 80,
        serverName: 'localhost',
        serverProtocol: @http_1_1,
        contentType: 'application/x-www-form-urlencoded',
        contentLength: 0,
        content: "",
        requestUri: '',
    ]

    def new(path, content) do
        %__MODULE__{
            scriptFilename: path,
            contentLength: String.length(content),
            content: content,
        }
    end
end