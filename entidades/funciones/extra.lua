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
		return true
	end

	return false

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

function extra:collides_object(obj,x,y,w,h)
	if obj.ox>x and obj.oy>y and obj.ox<w and obj.oy<h then
		return true
	else
		return false
	end
end

function extra:enviar_data_primordiar_jugador(obj,player_main)
	local data_player={}
	local data_enemigos={}

	if player_main then
		local cx,cy,cw,ch=player_main.cx,player_main.cy,player_main.cw,player_main.ch

		local vcx=cx-400
		local vcy=cy-400
		local vcw=cx+cw+400
		local vch=cy+ch+400

		for _, player in ipairs(obj.gameobject.players) do
			if player.obj then
				--if self:collides_object(player.obj,vcx,vcy,vcw,vch) then
					local t = {}
					local objeto = player.obj 
					local t={index=player.index,ox=objeto.ox,oy=objeto.oy,hp=objeto.hp,ira=objeto.ira,estados=objeto.estados,efecto=objeto.efecto_tenidos.current,friccion = objeto.friccion}
					table.insert(data_player,t)
				--end
			end
		end

		for _ ,enemigo in ipairs(obj.gameobject.enemigos) do
			if self:collides_object(enemigo,vcx,vcy,vcw,vch) then
				local t={index=enemigo.index,ox=enemigo.ox,oy=enemigo.oy,radio=enemigo.radio,fsm=enemigo.fsm.current,efecto=enemigo.efecto_tenidos.current,tipo=enemigo.tipo,estados=enemigo.estados,hp=enemigo.hp,ira=enemigo.ira}
				table.insert(data_enemigos,t)
			end
		end
	else
		for _, player in ipairs(obj.gameobject.players) do
			if player.obj then
				local t = {}
				local objeto = player.obj 
				local t={index=player.index,ox=objeto.ox,oy=objeto.oy,hp=objeto.hp,ira=objeto.ira,estados=objeto.estados,efecto=objeto.efecto_tenidos.current,friccion = objeto.friccion}
				table.insert(data_player,t)
			end
		end

		for _ ,enemigo in ipairs(obj.gameobject.enemigos) do
				local t={index=enemigo.index,ox=enemigo.ox,oy=enemigo.oy,radio=enemigo.radio,fsm=enemigo.fsm.current,efecto=enemigo.efecto_tenidos.current,tipo=enemigo.tipo,estados=enemigo.estados,hp=enemigo.hp,ira=enemigo.ira}
				table.insert(data_enemigos,t)
		end
	end

	return data_player,data_enemigos
end


function extra:ingresar_datos_personaje(obj,data)


	if obj.ox ~= data.ox and obj.oy ~= data.oy then
		obj.ox=data.ox
		obj.oy=data.oy
		obj.collider:setPosition( data.ox, data.oy )
	end

	obj.hp=data.hp
	obj.ira=data.ira
	obj.estados=data.estados
	obj.efecto_tenidos.current = data.efecto
	obj.friccion=data.friccion

	--[[if data.efecto =="ninguno" and obj.efecto_tenidos.current ~="ninguno" then
		obj.efecto_tenidos:normalidad()
	elseif data.efecto == "quemado" and obj.efecto_tenidos.current =="ninguno" then
		obj.efecto_tenidos:esquemado()
	elseif data.efecto == "congelado" and obj.efecto_tenidos.current =="ninguno" then
		obj.efecto_tenidos:escongelado()
	elseif data.efecto == "electrocutado"and obj.efecto_tenidos.current =="ninguno"  then
		obj.efecto_tenidos:eselectrocutado()
	end]]

end

function extra:ingresar_datos_enemigos(obj,data)

	obj.radio=data.radio
	obj.collider:setAngle(data.radio)

	if obj.ox ~= data.ox and obj.oy ~= data.oy then
		obj.ox=data.ox
		obj.oy=data.oy
		obj.collider:setPosition( data.ox, data.oy )
	end

	obj.hp=data.hp
	obj.ira=data.ira
	obj.estados=data.estados

	obj.efecto_tenidos.current=data.efecto
	obj.fsm.current=data.fsm

	--[[if data.efecto =="ninguno" and obj.efecto_tenidos.current ~="ninguno" then
		obj.efecto_tenidos:normalidad()
	elseif data.efecto == "quemado" and obj.efecto_tenidos.current =="ninguno" then
		obj.efecto_tenidos:esquemado()
	elseif data.efecto == "congelado" and obj.efecto_tenidos.current =="ninguno" then
		obj.efecto_tenidos:escongelado()
	elseif data.efecto == "electrocutado"and obj.efecto_tenidos.current =="ninguno"  then
		obj.efecto_tenidos:eselectrocutado()
	end

	if data.fsm == "rastreando" and obj.fsm.current ~= "rastreando" then
		obj.fsm:rastreando()
	elseif data.fsm == "alerta" and obj.fsm.current == "rastreando" then
		obj.fsm:alertado()
	elseif data.fsm == "atacando" and obj.fsm.current == "rastreando" then
		obj.fsm:atacando()
	end]]

end




return extra