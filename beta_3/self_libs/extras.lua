

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

function recibir_data_jugador(data,obj)
	for name,datos in pairs(data) do
   		obj[name]=datos
	end
end

function collides_object(obj,x,y,w,h)
	if obj.ox>x and obj.oy>y and obj.ox<w and obj.oy<h then
		return true
	end
end



