defmodule Exfpm.Client.Request do

    defstruct [
        identifier: nil,
        gatewayInterface: "FastCGI/1.0",
        scriptFilename: nil,
        serverSoftware: "ExFPM/fcgi-client",
        remoteAddress: "192.168.0.1", # TODO detect hostname with tcp_gen
        remotePort: 9985,
        serverAddress: "127.0.0.1",
        serverPort: 80,
        serverName: "localhost",
        serverProtocol: "HTTP/1.1",
        contentType: "application/x-www-form-urlencoded",
        contentLength: 0,
        content: "",
        requestUri: "",
        requestMethod: :GET,
    ]

    def new(path, content, request_method \\ :GET) do
        %__MODULE__{
            identifier: :rand.uniform(1_000_000),
            requestMethod: request_method,
            scriptFilename: path,
            contentLength: String.length(content),
            content: content,
        }
    end

    def params(%__MODULE__{
        gatewayInterface: gatewayInterface,
        requestMethod: requestMethod,
        requestUri: requestUri,
        scriptFilename: scriptFilename,
        serverSoftware: serverSoftware,
        remoteAddress: remoteAddress,
        remotePort: remotePort,
        serverAddress: serverAddress,
        serverPort: serverPort,
        serverName: serverName,
        serverProtocol: serverProtocol,
        contentType: contentType,
        contentLength: contentLength
    }) do
        %{
            :GATEWAY_INTERFACE => gatewayInterface,
			:REQUEST_METHOD    => requestMethod,
            :REQUEST_URI       => requestUri,
            :SCRIPT_FILENAME   => scriptFilename,
            :SERVER_SOFTWARE   => serverSoftware,
            :REMOTE_ADDR       => remoteAddress,
            :REMOTE_PORT       => remotePort,
			:SERVER_ADDR       => serverAddress,
			:SERVER_PORT       => serverPort,
			:SERVER_NAME       => serverName,
			:SERVER_PROTOCOL   => serverProtocol,
			:CONTENT_TYPE      => contentType,
			:CONTENT_LENGTH    => contentLength,
        }
    end
end
