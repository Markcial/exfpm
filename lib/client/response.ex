defmodule Exfpm.Client.Response do

    defstruct [id: nil, raw: "", duration: 0, headers: [], body: ""]
    
    @doc ~S"""
        iex> Exfpm.Client.Response.parse_headers("Content-Type : text/html\nEncoding: utf8")
        %{
            "Content-Type" => "text/html",
            "Encoding" => "utf8"
        }

    """
    def parse_headers(raw) do
        raw |> 
            String.split(<<10>>) |>
            Enum.reduce(%{}, fn x, acc -> 
                [k,v] = String.split(x, ":")
                Map.put_new(acc, String.trim(k), String.trim(v))
            end)
    end

    def new(id, content, duration) do
        IO.puts content
        IO.inspect String.split(content, "\n\n")
        
        #%__MODULE__{
        #    id: id,
        #    raw: content,
        #    duration: duration,
        #    headers: parse_headers(raw_headers),
        #    body: body,
        #}
    end
end
