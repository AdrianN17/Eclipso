local extra={}

function extra:enviar_data_jugador(obj,...)
	local args={...}
	local data={}
  
  if obj==nil then
    return nil
  end

	for _,arg in ipairs(args) do
		data[arg]=obj[arg]
	end

	return data
end

function extra:recibir_data_jugador(data,obj)
	for name,datos in pairs(data) do
   		obj[name]=datos
	end
end

return extra