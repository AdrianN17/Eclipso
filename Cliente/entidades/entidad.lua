local Class = require "libs.hump.class"
local sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"

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

	
	--cliente
	self.players={}
	self.balas={}



	self.tickRate = 1/60
    self.tick = 0

	self.client = sock.newClient("192.168.0.3", 22122)
	self.client:setSerialization(bitser.dumps, bitser.loads)
    self.client:setSchema("jugadores", {
        "index",
        "player_data",
        "balas_data",
    })

    

  

    self.client:on("player_id", function(num)
    	self.id_player=num  
    end)

    self.client:on("jugadores", function(data)
        local index = data.index
        local player = data.player_data
        local balas= data.balas_data
        

        if self.id_player and index  then
        	
        	if not self.players[index] then
        		self.players[index]={tx=0,ty=0}
        	end

        	local pl=self.players[index]

        	--recoger data entidad:recibir_data_jugador(data,obj,...)
        	self:recibir_data_jugador(player,pl,"ox","oy","estados","hp","ira")

        	if player.tx and player.ty then
        		pl.tx=player.tx
        		pl.ty=player.ty
        	end

        	if balas then
        		self.balas=balas
        	end
        end
    end)

	--camara
	self.camwiew={}
	self.camwiew.x,self.camwiew.y,self.camwiew.w,self.camwiew.h=self.cam:getWorld()

	
	self.cam:setScale(0.75)

	self.client:connect(eleccion)
end



function entidad:draw()
	
	self.cam:draw(function(l,t,w,h)
		if self.id_player then


	 		for _, player in pairs(self.players) do
	 			if player then
	 				love.graphics.circle("fill" ,player.ox,player.oy,20)

	 				if player.tx and player.ty and player.estados.atacando then
	 					love.graphics.circle("fill", player.tx,player.ty,10)
	 				end
	 			end
	 		end

	 		for _, bala in ipairs(self.balas) do
	 				love.graphics.circle("fill" ,bala.ox,bala.oy,5)
	 			end
	 		end
	end)

	if self.id_player then
        love.graphics.print("Player " .. self.id_player, 5, 25)
        love.graphics.print(#self.players,50,10)
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

        if self.id_player and self.players[self.id_player] then
            local pl=self.players[self.id_player]

			self.cam:setPosition( pl.ox,pl.oy)

			pl.rx,pl.ry=self:getXY()

			local datos=self:enviar_data_jugador(pl,"rx","ry")
			datos.camx,datos.camy,datos.camw,datos.camh=self.cam:getVisible()
			datos.camw=datos.camx+datos.camw
			datos.camh=datos.camy+datos.camh
		    self.client:send("datos", datos)
		end
    end
end

function entidad:keypressed(key)
	if self.client:getState() == "connected" and self.id_player then
		 local pl=self.players[self.id_player]

		 self.client:send("key_pressed", {key=key})
	end
end

function entidad:keyreleased(key)
	if self.client:getState() == "connected" and self.id_player then
		local pl=self.players[self.id_player]

		 self.client:send("key_released", {key=key})
	end
end

function entidad:mousepressed(x,y,button)
	if self.client:getState() == "connected" and self.id_player then
		local cx,cy=self.cam:toWorld(x,y)
		self.client:send("mouse_pressed", {x=cx,y=cy,button=button})
	end
end

function entidad:mousereleased(x,y,button)
	if self.client:getState() == "connected" and self.id_player then
		local cx,cy=self.cam:toWorld(x,y)
		self.client:send("mouse_released", {x=cx,y=cy,button=button})
	end
end

function entidad:wheelmoved(x,y) 
	if self.client:getState() == "connected" and self.id_player then
		self.client:send("wheel_moved", {x=x,y=y})
	end
end

function entidad:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getPosition())
	return cx,cy 
end

function entidad:getRadio(ox,oy)
	local mx,my=self:getXY()
	local r= math.atan2( my-oy, mx -ox)
	return r
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


return entidad