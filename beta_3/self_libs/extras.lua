

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

function extra_data(obj,x,y,w,h)
	local cx,cy,cw,ch=x,y,x+w,y+h

	local data_bala={}
  local data_enemigo={}
  local data_objetos={}
  
	for i,bala in ipairs(obj.gameobject.balas) do 
		if collides_object(bala,cx-100,cy-100,cw+100,ch+100) then
			local t=enviar_data_jugador(bala,"tipo_indice","ox","oy","radio")
			table.insert(data_bala,t)
		end
	end
  
  for i,enemigo in ipairs(obj.gameobject.enemigos) do 
		if collides_object(enemigo,cx-100,cy-100,cw+100,ch+100) then
			local t=enviar_data_jugador(enemigo,"tipo_indice","tipo_area","ox","oy","radio","hp","ira","iterator")
			table.insert(data_enemigo,t)
		end
	end
  
  for i,objeto in ipairs(obj.gameobject.objetos) do 
		if collides_object(objeto,cx-100,cy-100,cw+100,ch+100) then
			local t=enviar_data_jugador(objeto,"tipo_indice","ox","oy")
			table.insert(data_objetos,t)
		end
	end
  
  

	return data_bala,data_enemigo,data_objetos
end



