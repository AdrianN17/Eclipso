local Class = require "libs.hump.class"
local sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local data_cliente= require "data_cliente"

local entidad = Class{}



function entidad:init(cam,map,timer,signal,eleccion)
	--objetos principales
	self.cam=cam
	self.map=map
	--librerias
	self.timer=timer
	self.signal=signal

	
	--cliente
	self.players={}
	self.balas={}
	self.efectos={}



	self.tickRate = 1/60
    self.tick = 0

	self.client = sock.newClient(data_cliente.ip, data_cliente.port)
	self.client:setSerialization(bitser.dumps, bitser.loads)

	self.client:enableCompression()

    self.client:setSchema("jugadores", {
        "index",
        "player_data",
        "balas_data",
        "efectos_data",
    })

    self.client:on("player_id", function(num)
    	self.id_player=num  
    end)

    self.client:on("desconexion_player",function(data)
    	table.remove(self.players,data)
    end)

    self.client:on("jugadores", function(data)
        local index = data.index
        local player = data.player_data
        local balas= data.balas_data
        local efectos= data.efectos_data
        

        if self.id_player and index  then
        	
        	if not self.players[index] then
        		self.players[index]={z=0}
        	end

        	local pl=self.players[index]

        	--recoger data entidad:recibir_data_jugador(data,obj,...)
        	self:recibir_data_jugador(player,pl,"personaje","ox","oy","estados","hp","ira")

        	if player.tx and player.ty then
        		pl.tx=player.tx
        		pl.ty=player.ty
        	end

        	if balas then
        		self.balas=balas
        	end

        	if efectos then
        		self.efectos=efectos
        	end
        end
    end)

	--camara
	self.camwiew={}
	self.camwiew.x,self.camwiew.y,self.camwiew.w,self.camwiew.h=self.cam:getWorld()

	
	self.cam:setScale(0.75)

	self.client:connect(eleccion)

	self.check_detalles=false
end



function entidad:draw()
	
	self.cam:draw(function(l,t,w,h)
		if self.id_player then


	 		for _, player in pairs(self.players) do
	 			if player then
	 				lg.circle("fill" ,player.ox,player.oy,20)

	 				if player.tx and player.ty and player.estados.atacando and player.personaje=="C" then
	 					lg.circle("fill", player.tx,player.ty,10)
	 				end

	 				lg.print(player.hp .. " , " .. player.z ,player.ox,player.oy+100)

	 				if player.estados.protegido then
	 					lg.circle("line" ,player.ox,player.oy,30)
	 				end
	 			end
	 		end

	 		for _, bala in ipairs(self.balas) do
	 			lg.circle("fill" ,bala.ox,bala.oy,5)
	 			lg.print(bala.z,bala.ox,bala.oy-50)
	 		end

	 		for _ ,efec in ipairs(self.efectos) do
	 			if efec.tipo=="circulo" then
	 				lg.circle("line" ,efec.ox,efec.oy,15)
	 			elseif efec.tipo=="poligono" then
	 				lg.circle("line" ,efec.ox,efec.oy,20)
	 			end
	 		end
	 	end
	end)

	if self.id_player then
        lg.print("Player " .. self.id_player, 5, 25)
        lg.print(#self.players,50,10)
    else
        lg.print("No player number assigned", 5, 25)
    end

    lg.print("Ping : " .. self.client:getRoundTripTime(), 200,10)

    if self.check_detalles then
    	self:check_vidas_personajes(self.players)
    end

    lg.print(self.client:getState(), 5, 70)
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

			local datos=self:enviar_data_jugador(pl,"rx","ry","z")
			datos.camx,datos.camy,datos.camw,datos.camh=self.cam:getVisible()
			datos.camw=datos.camx+datos.camw
			datos.camh=datos.camy+datos.camh
		    self.client:send("datos", datos)
		end
    end
end

function entidad:keypressed(key)
	if self.client:getState() == "connected" and self.id_player  and key~="tab" then
		if key=="escape" then
			 self.client:disconnect()
		else
			 local pl=self.players[self.id_player]

			 self.client:send("key_pressed", {key=key})
		end
	elseif key=="tab" then
		self.check_detalles=true
	end
end

function entidad:keyreleased(key)
	if self.client:getState() == "connected" and self.id_player and key~="escape" and key~="tab" then
		local pl=self.players[self.id_player]

		self.client:send("key_released", {key=key})
	elseif key=="tab" then
		self.check_detalles=false
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
	local pl=self.players[self.id_player]

	pl.z=pl.z+y*5

	if pl.z>45 then
		pl.z=45
	elseif pl.z<0 then
		pl.z=0
	end
end

function entidad:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getPosition())
	return cx,cy 
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

function entidad:check_vidas_personajes(table)
	local x,y=25,100
	local j=1

	lg.print("\tJugadores activos\t",x,y-15)
	lg.print("********************",x,y)

	for i, obj in pairs(table) do
		if obj  then
			lg.print(i .. ".\t" .. obj.personaje .. "\t"  .. obj.hp  .. "\t" .. obj.ira , x,y+15*i )
			j=j+1
		end
	end

	lg.print("********************",x,y+15*(j+1))
end


return entidad