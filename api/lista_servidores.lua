local http = require "socket.http"
local ltn12 = require "ltn12" 
local mime = require "mime"
local json = require "libs.json.json"

local lista_servidores = {}

function lista_servidores:listar(pais_buscado,mapa_buscado)

	local response_body = {}
	local request_body = {}

	request_body.pais = pais_buscado or "All"
	request_body.mapa = mapa_buscado or "All"


	print(json:encode(request_body))

	local res,code,response_headers = http.request{
	  url="http://index_server.test/api.php",
	  method = "POST",
	  sink = ltn12.sink.table(response_body),
	  source = ltn12.source.string(json:encode(request_body))
  	}

	local data_lua =  json:decode(response_body[1])
	return data_lua or {}
end

return lista_servidores