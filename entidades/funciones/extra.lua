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

  local balas_data={}
  local data_enemigo={}
 
	for i,bala in ipairs(obj.gameobject.balas) do 
		local t=self:enviar_data_jugador(bala,"tipo","ox","oy","radio")
		table.insert(balas_data,t)
	end
  
  	for i,enemigo in ipairs(obj.gameobject.enemigos) do 
		local t=self:enviar_data_jugador(enemigo,"tipo","clase","ox","oy","radio","hp","ira","iterator")
		table.insert(data_enemigo,t)
	end
  
	return balas_data,data_enemigo
end

function extra:extra_destruibles(obj)
	local destruibles_data={}

	for i,destruible in ipairs(obj.gameobject.destruible) do 
		local t=self:enviar_data_jugador(destruible,"poligono","tipo")
		table.insert(destruibles_data,t)
	end

	return destruibles_data
end

function extra:extra_data_fija(obj)

	local objetos_data={}
  	local arboles_data={}
  	local inicios_data={}


	for i,objeto in ipairs(obj.gameobject.objetos) do 
		local t=self:enviar_data_jugador(objeto,"tipo","ox","oy","radio")
		table.insert(objetos_data,t)
	end
  
  	for i,arbol in ipairs(obj.gameobject.arboles) do 
		local t=self:enviar_data_jugador(arbol,"tipo","ox","oy","radio")
		table.insert(arboles_data,t)
	end

	for i,pi in ipairs(obj.gameobject.inicios) do
		local t=self:enviar_data_jugador(pi,"tipo","ox","oy","radio")
		table.insert(inicios_data,t)
	end

	return objetos_data,arboles_data,inicios_data
end

function extra:dano(objetivo,dano)


	objetivo.hp=objetivo.hp-(dano+dano*(objetivo.ira/objetivo.max_ira))

	objetivo.ira=objetivo.ira+dano*0.5

	if objetivo.ira>objetivo.max_ira then
		objetivo.ira=objetivo.max_ira
	end

	if objetivo.hp<1 then
		objetivo.estados.vivo=false
	end

end

function extra:efecto(objetivo,bala)
	if objetivo.efecto_tenidos.current=="ninguno" then
		local azar = lm.random(1,20)

		if bala.efecto=="quemadura" then
			if azar%3==0 then
				objetivo.efecto_tenidos:esquemado()
			end
		elseif bala.efecto=="paralisis" then
			if azar%5==0 then
				objetivo.efecto_tenidos:eselectrocutado()
			end
		elseif bala.efecto=="congelamiento" then
			if azar%10==0 then
				objetivo.efecto_tenidos:escongelado()
			end
		end
	end
end

function extra:empujon(realiza,recibe,direccion)
	local r = realiza.radio-math.pi/2
    local ix,iy=math.cos(r),math.sin(r)
    recibe.collider:applyLinearImpulse( 10000*ix*direccion,10000*iy*direccion )
end

return extra