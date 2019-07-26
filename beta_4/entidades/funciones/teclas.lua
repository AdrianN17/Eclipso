local teclas={}

function teclas:validar(key)
	local teclas_disponibles={"a","w","s","d","e","r"}

	for _,tecla in ipairs(teclas_disponibles) do

		if tecla==key then
			return true
		end
	end

	return false
end

return teclas