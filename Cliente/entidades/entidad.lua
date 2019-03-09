local Class = require "libs.hump.class"
local sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local player = {require "entidades.personajes.A", require "entidades.personajes.S" , require "entidades.personajes.X" , require "entidades.personajes.R" , require "entidades.personajes.MrH_S" , require "entidades.personajes.C"}
local HC_collisions= require "libs.HC_collisions.HC_collisions"


local entidad = Class{}

function entidad:init(collider,cam,map,timer,signal,vector,eleccion)
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

	--cliente
	self.players={}


	self.tickRate = 1/60
    self.tick = 0

	self.client = sock.newClient("192.168.0.3", 22122)
	self.client:setSerialization(bitser.dumps, bitser.loads)
    self.client:setSchema("jugadores", {
        "index",
        "player",
    })


    self.client:on("playerNum", function(num)
    	self.id_player=num
    	print(eleccion)
    	self.players[num]=player[eleccion](self,100,100,num)   
    end)

    self.client:on("jugadores", function(data)
        local index = data.index
        local player = data.player_data

        -- only accept updates for the other player
        if self.id_player and index ~= self.id_player then
            self.players[index].ox=player.ox
            self.players[index].oy=player.oy
            self.players[index].radio=player.radio
            self.players[index].estados=player.estados
            self.players[index].movimiento=player.movimiento
        end
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

	self.client:connect(eleccion)
end

function entidad:draw()
	
	self.cam:draw(function(l,t,w,h)
 		
 		self.collisions:draw()
	end)

	if self.id_player then
        love.graphics.print("Player " .. self.id_player, 5, 25)
    else
        love.graphics.print("No player number assigned", 5, 25)
    end
end


function entidad:update(dt)
	self.client:update()
	

	if self.client:getState() == "connected" then
        self.tick = self.tick + dt
    end

    if self.tick >= self.tickRate then
        self.tick = 0

        if self.id_player then
            self.collisions:update(dt)
			self.cam:setPosition( self.players[self.id_player].ox, self.players[self.id_player].oy)

			local pl=self.players[self.id_player]
            self.client:send("datos", {ox=pl.ox,oy=pl.oy,radio=pl.radio,estados=pl.estados,movimiento=pl.movimiento})
        end
    end
end

function entidad:keypressed(key)
	if self.client:getState() == "connected" then
		self.players[self.id_player]:keypressed(key)
	end
end

function entidad:keyreleased(key)
	if self.client:getState() == "connected" then
		self.players[self.id_player]:keyreleased(key)
	end
end

function entidad:mousepressed(x,y,button)
	if self.client:getState() == "connected" then
		local cx,cy=self.cam:toWorld(x,y)
		self.players[self.id_player]:mousepressed(cx,cy,button)
	end
end

function entidad:mousereleased(x,y,button)
	if self.client:getState() == "connected" then
		local cx,cy=self.cam:toWorld(x,y)
		self.players[self.id_player]:mousereleased(cx,cy,button)
	end
end

function entidad:wheelmoved(x,y) 
	if self.client:getState() == "connected" then
		self.players[self.id_player]:wheelmoved(x,y)
	end
end

function entidad:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getPosition())
	return cx,cy 
end


return entidad