local Class = require "libs.hump.class"
local sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"

require "libs.extra.extras"

local entidades=Class{}

local personajes={}
local enemigos={}
local objetos={}

function entidades:init(cam,timer,signal,vector,eleccion,map)
	self.cam=cam
	self.timer=timer
	self.signal=signal
	self.vector=vector

	self.map=map


	personajes={
		require "entidades.personajes.Aegis",
		require "entidades.personajes.Solange",
		require "entidades.personajes.Xeon",
		require "entidades.personajes.Radian",
		require "entidades.personajes.HS",
		require "entidades.personajes.Cromwell"
	}

	enemigos={
		require "entidades.enemigos.muymuy",
		require "entidades.enemigos.cangrejos"

	}

	objetos={
		Arbol= require "entidades.objetos.mapa.arbol",
		Roca= require "entidades.objetos.mapa.roca"
	}

	self.gameobject={}

	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}



	self.world = love.physics.newWorld(0, 0, false)



	
    self.world:setCallbacks(self:callbacks())


	self:add_obj("players",personajes[eleccion](self,100,100,1))



	self.ox,self.oy=self.gameobject.players[1].ox,self.gameobject.players[1].oy

	self:init_servidor()

	--self:add_obj("enemigos",enemigos[2](self,500,500))
	self:add_obj("enemigos",enemigos[2](self,300,400))


	self:map_init()
end

function entidades:enter()

	
end

function entidades:draw()
	local cx,cy,cw,ch=self.cam:getVisible()
	
	

	self.cam:draw(function(l,t,w,h)
		
		self.map:draw(-cx,-cy,1,1)

		for i, obj in pairs(self.gameobject) do
			for _, obj2 in pairs(obj) do
				if obj2 then
					obj2:draw()
				end
			end
		end

		for _, body in pairs(self.world:getBodies()) do
		    for _, fixture in pairs(body:getFixtures()) do
		        local shape = fixture:getShape()
		 
		        if shape:typeOf("CircleShape") then
		            local cx, cy = body:getWorldPoints(shape:getPoint())
		            love.graphics.circle("line", cx, cy, shape:getRadius())
		        elseif shape:typeOf("PolygonShape") then
		            love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
		        else
		            love.graphics.line(body:getWorldPoints(shape:getPoints()))
		        end
		    end
	    end
	end)


	lg.print("jugadores : " .. (self.server:getClientCount()+1) ,10,30)
	lg.print("IP : " .. (self.server:getAddress()) , 10, 5)

end

function entidades:update(dt)
	self:update_server(dt)
end

function entidades:keypressed(key)
	if self.gameobject.players[1] then
		self.gameobject.players[1]:keypressed(key)

		if key=="k" then
			self.gameobject.players[1].vivo=false
		end
	end
end

function entidades:keyreleased(key)
	if self.gameobject.players[1] then
		self.gameobject.players[1]:keyreleased(key)
	end
end

function entidades:mousepressed(x,y,button)
	if self.gameobject.players[1] then

		local cx,cy=self.cam:toWorld(x,y)
		self.gameobject.players[1]:mousepressed(cx,cy,button)
	end
end

function entidades:mousereleased(x,y,button)
	if self.gameobject.players[1] then
		local cx,cy=self.cam:toWorld(x,y)
		self.gameobject.players[1]:mousereleased(cx,cy,button)
	end
end

function entidades:wheelmoved(x,y)
	if self.gameobject.players[1] then
		self.gameobject.players[1]:wheelmoved(x,y)
	end
end



function entidades:add_obj(name,obj)


	table.insert(self.gameobject[name],obj)
end

function entidades:remove_obj(name,obj)

	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function entidades:remove_to_nill(name,obj)
	for i, e in pairs(self.gameobject[name]) do
		if e and e==obj  then
			self.gameobject[name][i]=nil
			return
		end
	end
end

function entidades:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())
	return cx,cy
end

--[[
function entidades:collisions()
	self:collisions_detection("players","balas",function(obj1,obj2)

 		if  obj1.collider:isTouching(obj2.collider) then
 			if not obj1.estados.protegido  then


 				obj1:attack(obj2.daño)

	 			if obj2.efecto then
					obj1:efecto(obj2.efecto)
				end

	 			obj2:remove()
 			end
 		end

	end)


end

function entidades:collisions_detection(a,b,fun)
	for _,obj1 in pairs(self.gameobject[a]) do
		for _,obj2 in pairs(self.gameobject[b]) do
			if obj1 and obj2 then
				fun(obj1,obj2)
			end
		end
	end
end]]


function entidades:callbacks()
	local beginContact =  function(a, b, coll)

		local obj1=nil
 		local obj2=nil

		local o1,o2=a:getUserData(),b:getUserData()

		

		if o1.pos<o2.pos then
			obj1=o1
			obj2=o2
		else
			obj1=o2
			obj2=o1
		end


 		
 		local x,y=coll:getNormal()


 		print(obj1.data,obj2.data,obj1.pos,obj2.pos)
 		

 		if obj1.data=="personaje" and obj2.data=="bala" then
 			if not obj1.obj.estados.protegido  then


	 			obj1.obj:attack(obj2.obj.daño)

	 			if obj2.obj.efecto then
					obj1.obj:efecto(obj2.obj.efecto)
				end

	 			obj2.obj:remove()
	 		end

 		elseif obj1.data=="escudo" and obj2.data=="bala"  then

 			if obj1.obj.estados.protegido  then

 				if obj1.obj.reflejo then

 					local r=math.atan2(y,x)
 					local ix,iy=math.cos(r),math.sin(r)

 					obj1.obj:reflejo(obj2.obj,-ix,-iy) 
 				else
 					obj2.obj:remove()
 				end
 					
 			end
 		elseif obj1.data=="personaje" and obj2.data=="campo_electrico" then
 			obj1.obj:efecto("paralisis",true)
 		elseif obj1.data=="personaje" and obj2.data=="barrera_de_fuego" then
 			obj1.obj:efecto("quemadura",true)
 		elseif obj1.data=="personaje" and obj2.data=="explosion_plasma" then
 			obj1.obj:efecto("plasma",true)
 		elseif obj1.data=="bala" and obj2.data=="cubo_de_hielo" then
 			if obj1.obj.name=="bala-hielo" then
		 		obj2.obj:resize()
		 		obj1.obj:remove()
	 		elseif obj1.obj.name=="bala-fuego" then
	 			obj2.obj:attack(obj1.obj.daño*2)
	 			obj1.obj:remove()
	 		else
	 			obj2.obj:attack(obj1.obj.daño)
	 			obj1.obj:remove()
	 		end
	 	elseif obj1.data=="bala" and obj2.data=="barrera_de_fuego" then
	 		if obj1.obj.name=="bala-hielo" then
	 			obj1.obj:remove()
	 			obj2.obj:remove()
	 		end
 		elseif obj1.data=="melee" and obj2.data=="bala" then
 			if obj1.obj.estados.atacando then
 				obj2.obj:remove()
 			end
 		elseif obj1.data=="melee" and obj2.data=="cubo_de_hielo" then
 			if obj1.obj.estados.atacando then
 				obj2.obj:attack(obj1.obj.melee_attack)
 				obj1.obj.estados.atacando=false
 			end
 		elseif obj1.data=="melee" and obj2.data=="personaje" then
 			if obj1.obj.estados.atacando then
 				
 				local r=math.atan2(y,x)
 				local ix,iy=math.cos(r),math.sin(r)

 				obj2.obj.collider:applyLinearImpulse( 10000*-ix,10000*-iy )

 				obj2.obj:attack(obj1.obj.melee_attack)
 				obj1.obj.estados.atacando=false

 				obj2.obj.estados.atacado=true
 				obj2.obj:obj_atacado()
 			end
 		elseif obj1.data=="melee" and obj2.data=="escudo" then
 			if obj1.obj.estados.atacando and obj1.obj.estados.protegido then
 				local r=math.atan2(y,x)
 				local ix,iy=math.cos(r),math.sin(r)

 				obj1.obj.collider:applyLinearImpulse( 10000*-ix,10000*-iy )
 				obj1.obj.estados.atacando=false
 			end
 		elseif obj1.data=="personaje" and obj2.data=="enemigo_vision" then




	 			obj2.obj.sensor_activado=true

	 			obj2.obj.atacante=false

	 			obj2.obj:almacenar_enemigos(obj1.obj)



 		--[[elseif obj1.data=="escudo" and obj2.data=="personaje" then
	 		--agregado

	 		if obj1.obj.estados.protegido then

	 			local r=math.atan2(y,x)
 				local ix,iy=math.cos(r),math.sin(r)

 				obj2.obj.collider:applyLinearImpulse( 1000*-ix,1000*-iy )

	 		end]]
	 	elseif obj1.data=="bala" and obj2.data=="enemigos" then
	 		obj2.obj:attack(obj1.obj.daño)

 			if obj1.obj.efecto then
				obj2.obj:efecto(obj1.obj.efecto)
			end

			if #obj2.obj.presas==0 then


				obj2.obj.radio_atacante=obj1.obj.radio

				obj2.obj.atacante=true

				obj2.obj:detener_caza()
			end

	 		obj1.obj:remove()
	 	elseif obj1.data=="personaje" and obj2.data=="melee_enemigo" then
	 		local r=math.atan2(y,x)
 			local ix,iy=math.cos(r),math.sin(r)

 			obj1.obj.collider:applyLinearImpulse( 10000*-ix,10000*-iy )

 			obj1.obj:attack(obj2.obj.melee_attack)

 			obj1.obj.estados.atacado=true
 			obj1.obj:obj_atacado()

 		elseif obj1.data=="melee" and obj2.data=="enemigos" then
 			if obj1.obj.estados.atacando then

 				local r=math.atan2(y,x)
 				local ix,iy=math.cos(r),math.sin(r)

 				obj2.obj.collider:applyLinearImpulse( 10000*ix,10000*iy )
 				
 				obj2.obj:attack(obj1.obj.melee_attack)
 				obj1.obj.estados.atacando=false

 				obj2.obj.estados.atacado=true
 				obj2.obj:obj_atacado()


 				if #obj2.obj.presas==0 then
					obj2.obj.radio_atacante=obj1.obj.radio

					obj2.obj.atacante=true

					obj2.obj:detener_caza()
				end
				
 			end
 		elseif obj1.data=="escudo" and obj2.data=="melee_enemigo" then
 			if obj1.obj.estados.protegido then

 				local r=math.atan2(y,x)
 				local ix,iy=math.cos(r),math.sin(r)

 				obj2.obj.collider:applyLinearImpulse( 10000*ix,10000*iy )

 			end
 		elseif obj1.data=="enemigo_sensor" and (obj2.data=="roca" or obj2.data=="arbol") then
 	

 			
 			obj1.obj:new_radio(obj2.obj)

 			
 			obj1.obj.atacante=false
 			obj1.obj.sensor_activado=false

 			obj1.obj.touch=true
 		
 			
 		end
	end


	local endContact =  function(a, b, coll)
 		local obj1=a:getUserData()
 		local obj2=b:getUserData()
 		local x,y=coll:getNormal()

 		if obj1.data=="personaje" and obj2.data=="enemigo_vision" then

 			obj2.obj:olvidar_enemigos(obj1.obj)
 		elseif obj1.data=="enemigo_sensor" and (obj2.data=="roca" or obj2.data=="arbol") then
 			

 			obj1.obj.touch=false
 		
 			
 		end
	end

	local preSolve =  function(a, b, coll)

		--aqui no va colisiones con fixture
		local obj1=a:getUserData()
 		local obj2=b:getUserData()
 		local x,y=coll:getNormal()

 		
 		if obj1.data=="bala" and obj2.data=="bala" then
 			obj1.obj:collides_bala(obj2.obj)
 			obj2.obj:collides_bala(obj1.obj)
 		end
	end

	local postSolve =  function(a, b, coll, normalimpulse, tangentimpulse)
 		--local obj1=a:getUserData()
 		--local obj2=b:getUserData()

	end

	return beginContact,endContact,preSolve,postSolve
end

function entidades:init_servidor()
	self.tickRate = 1/60
    self.tick = 0

	self.server = sock.newServer(_G.detalles.ip, _G.detalles.port, 4)
	self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:enableCompression()


	--cuando se conecta
	self.server:on("connect", function(data, client)
		local index=client:getIndex()
        client:send("player_id", index+1)
        --table.insert(self.gameobject.players, personajes[data](self,100,100,index+1))
        self.gameobject.players[index+1] = personajes[data](self,100,100,index+1)
    end)


    self.server:on("disconnect", function(data, client)
    	local index =client:getIndex()

    	if self.gameobject.players[index+1] then

	    	self.gameobject.players[index+1]:remove()
	    	--table.remove(self.gameobject.players,index+1)
	    	self.gameobject.players[index+1]=nil

	    end

    	self.server:sendToAll("desconexion_player", (index+1))
    end)


    self.server:on("datos", function(datos, client)
        local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

        if pl then
        	recibir_data_jugador(datos,pl)
        end
    end)

    --callbacks

    self.server:on("mouse_pressed" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

        if pl then
        	pl:mousepressed(datos.x,datos.y,datos.button)
        end
    end)

    self.server:on("mouse_released" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

        if pl then
        	pl:mousereleased(datos.x,datos.y,datos.button)
        end
    end)

    self.server:on("key_pressed" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

        if pl then
        	pl:keypressed(datos.key)
        end
    end)

    self.server:on("key_released" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

         if pl then
        	pl:keyreleased(datos.key)
        end
    end)

end

function entidades:update_server(dt)
	self.server:update(dt)
	self.map:update(dt)
	self.world:update(dt)
	--self:collisions()

	self.tick = self.tick + dt

	if self.tick >= self.tickRate then
        self.tick = 0

        

		for i, obj in pairs(self.gameobject) do
			for _, obj2 in pairs(obj) do
				if obj2 then
					obj2:update(dt)
				end
			end
		end

		if self.gameobject.players[1] then

			self.gameobject.players[1].rx,self.gameobject.players[1].ry=self:getXY()

			self.cam:setPosition(self.gameobject.players[1].ox,self.gameobject.players[1].oy)
			self.ox,self.oy=self.gameobject.players[1].ox,self.gameobject.players[1].oy
		else
			self.cam:setPosition(self.ox,self.oy)
		end


        for i, player in pairs(self.gameobject.players) do
        	if player then
	        	--enviar
        		

	        	local extra_data=self:extra_data_all()
        		--local extra_data=self:extra_data(player.camx,player.camy,player.camw,player.camh)
        		local player_data=player:send_data()

            	self.server:sendToAll("jugadores", {i,player_data,extra_data})
            	--las balas deben ir aca para limitarla segun su camara
	        end
        end
    end
end

function entidades:extra_data(x,y,w,h)
	local cx,cy,cw,ch=x,y,x+w,y+h

	local data={}

	for i,bala in ipairs(self.gameobject.balas) do 
		if collides_object(bala,cx-100,cy-100,cw+100,ch+100) then
			local t=bala:send_data()
			table.insert(data,t)
		end
	end

	for i,efecto in ipairs(self.gameobject.efectos) do 
		if collides_object(efecto,cx-100,cy-100,cw+100,ch+100) then
			local t=efecto:send_data()
			table.insert(data,t)
		end
	end

	return data
end

function entidades:extra_data_all()
	local data={}

	for i,bala in ipairs(self.gameobject.balas) do 
			local t=bala:send_data()
			table.insert(data,t)
	end

	for i,efecto in ipairs(self.gameobject.efectos) do 
		
			local t=efecto:send_data()
			table.insert(data,t)
	end

	return data
end




function entidades:quit()
    self.server:destroy()
end

function entidades:map_init()
	for _, layer in ipairs(self.map.layers) do
		if layer.type=="tilelayer" then
			--self:get_tile(layer)
		elseif layer.type=="objectgroup" then
			self:get_objects(layer)
		end
	end

	--self.map:removeLayer("Objetos")
end

function entidades:get_objects(objectlayer)
	if objectlayer.name=="Objetos" then
		for _, obj in pairs(objectlayer.objects) do
			
			objetos[obj.name](obj.x+obj.width/2,obj.y+obj.height/2,obj.width,obj.height,obj.properties.hp,obj.shape,self)
			
		end
	end


end

return entidades

