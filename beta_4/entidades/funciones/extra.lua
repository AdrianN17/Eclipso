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

function extra:extra_data(obj)
	--local cx,cy,cw,ch=x,y,x+w,y+h

  local balas_data={}
  local objetos_data={}
  local arboles_data={}
  local inicios_data={}

  
	for i,bala in ipairs(obj.gameobject.balas) do 
		--if collides_object(bala,cx-100,cy-100,cw+100,ch+100) then
			local t=self:enviar_data_jugador(bala,"tipo","ox","oy","radio")
			table.insert(balas_data,t)
		--end
	end
  
  --[[for i,enemigo in ipairs(obj.gameobject.enemigos) do 
		--if collides_object(enemigo,cx-100,cy-100,cw+100,ch+100) then
			local t=enviar_data_jugador(enemigo,"tipo_indice","tipo_area","ox","oy","radio","hp","ira","iterator")
			table.insert(data_enemigo,t)
		--end
	end]]
  
  	for i,objeto in ipairs(obj.gameobject.objetos) do 
		--if collides_object(objeto,cx-100,cy-100,cw+100,ch+100) then
			local t=self:enviar_data_jugador(objeto,"tipo","ox","oy","radio")
			table.insert(objetos_data,t)

		--end
	end
  
  	for i,arbol in ipairs(obj.gameobject.arboles) do 
		--if collides_object(arbol,cx-100,cy-100,cw+100,ch+100) then
			local t=self:enviar_data_jugador(arbol,"tipo","ox","oy","radio")
			table.insert(arboles_data,t)
		--end
	end

	for i,pi in ipairs(obj.gameobject.inicios) do
		local t=self:enviar_data_jugador(pi,"tipo","ox","oy","radio")
		table.insert(inicios_data,t)
	end

	return balas_data,objetos_data,arboles_data,inicios_data
end

return extra