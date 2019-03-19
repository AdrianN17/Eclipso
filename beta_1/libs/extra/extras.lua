function collides(table,x,y)
	if x> table.x and x<table.x+table.w and y>table.y and y<table.y+table.h then
		return true
	end
end

function enviar_data_jugador(obj,...)
	local args={...}
	local data={}

	for _,arg in ipairs(args) do
		data[arg]=obj[arg]
	end

	return data
end

function recibir_data_jugador(data,obj,...)
	local args={...}
	local obj=obj

	for _,arg in ipairs(args) do
		obj[arg]=data[arg]
	end
end
