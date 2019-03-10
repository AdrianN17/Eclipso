local Class = require "libs.hump.class"
local sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local Player = {require "entidades.personajes.A", require "entidades.personajes.S" , require "entidades.personajes.X" , require "entidades.personajes.R" , require "entidades.personajes.MrH_S" , require "entidades.personajes.C"}
local HC_collisions= require "libs.HC_collisions.HC_collisions"


local entidad = Class{}

function entidad:init(collider,cam,map,timer,signal,vector)
	--objetos principales
	self.collider=collider
	self.cam=cam
	self.map=map
	--librerias
	self.timer=timer
	self.signal=signal
	self.vector=vector

	--colisiones
	self.collisions=HC_collisions(self.collider)
	--clases de colisiones
	self.collisions:add_collision_class("player")
	self.collisions:add_collision_class("melee")
	self.collisions:add_collision_class("balas")
	self.collisions:add_collision_class("suelo_llamas")
	self.collisions:add_collision_class("campo_electrico")
	self.collisions:add_collision_class("barrera_hielo")
	self.collisions:add_collision_class("explosion_plasma")
	--jugadores
	self.players={}


	---Servidor
	self.tickRate = 1/60
    self.tick = 0

	self.server = sock.newServer("192.168.0.3", 22122, 4)
	self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:on("connect", function(data, client)
        client:send("player_id", client:getIndex())
        table.insert(self.players, Player[data](self,100,100,client:getIndex()))
    end)

    self.server:on("datos", function(datos, client)
        local index = client:getIndex()
        local pl=self.players[index]
        --recibe recibir_data_jugador(data,obj,...)

        self:recibir_data_jugador(datos,pl,"rx","ry","camx","camy","camw","camh")
    end)



    self.server:on("mouse_pressed" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.players[index]

        pl:mousepressed(datos.x,datos.y,datos.button)

    end)

    self.server:on("mouse_released" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.players[index]

        pl:mousereleased(datos.x,datos.y,datos.button)

    end)

    self.server:on("key_pressed" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.players[index]

        pl:keypressed(datos.key)

    end)

    self.server:on("key_released" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.players[index]

        pl:keyreleased(datos.key)

    end)





	--colisiones


	self.collisions:add_collisions_filter_parameter("bala-barrera_hielo","balas","barrera_hielo",function(obj1,obj2) 
		if obj1.name=="bala-hielo" then
			if obj2.scale < 1.50  then
				obj2:resize(1)
				obj1:remove()
			end
			
		elseif obj1.name=="bala-fuego" then
			obj2:remove()
			obj1:remove()
		elseif obj1.name=="bala-electricidad" or obj1.name=="bala-ectoplasma" or obj1.name=="bala-plasma" or obj1.name=="bala-semilla" or obj1.name=="bala-aguja" then
			obj2:attack(obj1.daño)
			obj1:remove()
		end
	end)

	self.collisions:add_collisions_filter_parameter("bala-suelo_llamas","balas","suelo_llamas",function(obj1,obj2)
		if obj1.name=="bala-hielo" then
			obj1:remove()
			obj2:remove()
		end
	end)

	self.collisions:add_collisions_filter_parameter("player-barrera_hielo","player","barrera_hielo","solido")

	self.collisions:add_collisions_filter_parameter("player-balas","player","balas",function(obj1,obj2)
		if obj1.creador ~= obj2.creador then
			
			obj1:attack(obj2.daño)

			if obj2.efecto then
				obj1:efecto(obj2.efecto)
			end

			obj2:remove()

		end
	end)


	self.collisions:add_collisions_filter_parameter("player-balas-protegido","player","balas",function(obj1,obj2,dx,dy)
		if obj1.creador ~= obj2.creador and obj2.type~= "bala-ectoplasma" then
			if obj1.estados.protegido then
				if obj1.reflejo then
					obj1:reflejo(obj2,dx,dy)
				else
					obj2:remove()
				end
			end
		end
	end,"escudo")



	self.collisions:add_collisions_filter_parameter("player-suelo_llamas","player","suelo_llamas", function(obj1,obj2)
		obj1:efecto("quemadura",true)
	end)

	self.collisions:add_collisions_filter_parameter("player-campo_electrico","player","campo_electrico", function(obj1,obj2)
		obj1:efecto("paralisis",true)
	end)

	self.collisions:add_collisions_filter_parameter("player-suelo_llamas","player","explosion_plasma", function(obj1,obj2)
		obj1:efecto("plasma",true)
	end)


	self.collisions:add_collisions_filter_parameter("balas-balas","balas","balas",function(obj1,obj2)
		if obj1.creador ~= obj2.creador then
			obj1:collides_bala(obj2)
			obj2:collides_bala(obj1)
		end
	end)


	self.collisions:add_collisions_filter_parameter("melee-balas","melee","balas", function(obj1,obj2)
		if obj1.creador ~= obj2.creador and obj1.player.estados.atacando then
			obj2:remove()
		end
	end,"melee_shape")

	self.collisions:add_collisions_filter_parameter("melee-balas","melee","player", function(obj1,obj2)
		if obj1.creador ~= obj2.creador and not obj2.estados.atacado and obj1.player.estados.atacando then
			obj2:attack(obj1.damage)
			obj2.estados.atacado=true
			obj2.timer:after(1,function() obj2.estados.atacado=false end)
		end
	end,"melee_shape")

	self.collisions:add_collisions_filter_parameter("player_escudo-player","player","player", function(obj1,obj2,dx,dy)
		if obj1.creador ~= obj2.creador and obj1.estados.protegido   then
			obj2.collider:move(-dx,-dy)
			obj2.escudo:move(-dx,-dy)
			for _,point in ipairs(obj2.points) do
		    	point:move(-dx,-dy)
		    end

		    if obj2.melee then
		    	obj2.melee:moves(-dx,-dy)
		    end
		end
	end,"escudo")

	self.collisions:add_collisions_filter_parameter("melee-barrera_hielo","melee","barrera_hielo", function(obj1,obj2)
		if obj1.player.estados.atacando then
			obj2:attack(obj1.damage)
			obj1.player.estados.atacando=false
		end 

	end,"melee_shape" )

	--camara
	self.camwiew={}
	self.camwiew.x,self.camwiew.y,self.camwiew.w,self.camwiew.h=self.cam:getWorld()


	self.cam:setScale(0.75)
end

function entidad:draw()
	self.cam:draw(function(l,t,w,h)
 		
 		self.collisions:draw()
	end)
end

function entidad:update(dt)
	self.server:update()

	local enoughPlayers = #self.server.clients >= 4

    --if not enoughPlayers then return end
	

    self.tick = self.tick + dt

	if self.tick >= self.tickRate then
        self.tick = 0

        self.collisions:update(dt)

        for i, player in pairs(self.players) do
        	if player then
	        	--enviar
        		local player_data=self:enviar_data_jugador(player,"ox","oy","estados","hp","ira")

        		if player.tx and player.ty then
        			player_data.tx=player.tx
        			player_data.ty=player.ty
        		end

        		local balas_data=self:get_balas(player.camx,player.camy,player.camw,player.camh)
        		local efectos_data=self:get_efectos(player.camx,player.camy,player.camw,player.camh)
            	self.server:sendToAll("jugadores", {i, player_data,balas_data,efectos_data})
            	--las balas deben ir aca para limitarla segun su camara
	        end
        end
    end
end

function entidad:enviar_data_jugador(obj,...)
	local args={...}
	local data={}
	
	for _,arg in ipairs(args) do
		data[arg]=obj[arg]
	end

	return data
end

function entidad:recibir_data_jugador(data,obj,...)
	local args={...}
	local obj=obj 

	for _,arg in ipairs(args) do
		obj[arg]=data[arg]
	end
end

function entidad:get_balas(x,y,w,h)
	local data={}
	for i,balas in ipairs(self.collisions.collisions_class.balas) do
		if balas.ox>x-100 and balas.oy>y-100 and balas.ox<w and balas.oy<h then
			table.insert(data,{ox=balas.ox,oy=balas.oy})
		end
	end

	return data
end

function entidad:get_efectos(x,y,w,h)
	local data={}
	local tabla={"suelo_llamas","campo_electrico","barrera_hielo","explosion_plasma"}

	for _,name in pairs(tabla) do
		for _,obj in pairs(self.collisions.collisions_class[name]) do
			if obj.tipo =="circulo" then
				table.insert(data,{tipo=obj.tipo,ox=obj.ox,oy=obj.oy})
			elseif obj.tipo=="poligono" then
				table.insert(data,{tipo=obj.tipo,ox=obj.ox,oy=obj.oy,escala=obj.scale,radio=obj.radio})
			end
		end
	end

	return data
end

return entidad