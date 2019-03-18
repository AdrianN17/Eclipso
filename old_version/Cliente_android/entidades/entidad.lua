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


	local x,y=love.graphics.getDimensions( )
	--mando
	self.mando={{touch=false,mx=40,my=y-150,mw=30,mh=80,data="a"},{touch=false,mx=120,my=y-150,mw=30,mh=80,data="d"},{touch=false,mx=40,my=y-190,mw=110,mh=30,data="w"},{touch=false,mx=40,my=y-60,mw=110,mh=30,data="s"},
	{touch=false,mx=x-150,my=y-150,mw=30,mh=80},{touch=false,mx=x-70,my=y-150,mw=30,mh=80,data="q"},{touch=false,mx=x-150,my=y-190,mw=110,mh=30,data="e"},{touch=false,mx=x-150,my=y-60,mw=110,mh=30,data="r"},
	{touch=false,mx=x-60,my=y-300,mw=40,mh=40},{touch=false,mx=x-60,my=y-380,mw=40,mh=40},{touch=false,mx=x-40,my=40,mw=20,mh=20}}


	--tipo de bala
	self.t_bala=1

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

	--mando

	for _, btn in pairs(self.mando) do
   		love.graphics.rectangle("fill",btn.mx,btn.my,btn.mw,btn.mh)
    end



	
	self.cam:draw(function(l,t,w,h)
		if self.id_player then


	 		for _, player in pairs(self.players) do
	 			if player then
	 				lg.circle("fill" ,player.ox,player.oy,20)

	 				if player.tx and player.ty and player.estados.atacando and player.personaje=="C" then
	 					lg.circle("fill", player.tx,player.ty,10)
	 				end

	 				lg.print(player.hp .. " , " .. player.z ,player.ox,player.oy+55)

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

function entidad:touchpressed( id, x, y, dx, dy, pressure )
	if self.client:getState() == "connected" and self.id_player then
		local pl=self.players[self.id_player]

		if self:collides(self.mando[1],x,y) then
			
			self.client:send("key_pressed", {key=self.mando[1].data})

		elseif self:collides(self.mando[2],x,y) then
			self.client:send("key_pressed", {key=self.mando[2].data})

		elseif self:collides(self.mando[3],x,y) then
			self.client:send("key_pressed", {key=self.mando[3].data})

		elseif self:collides(self.mando[4],x,y) then
			self.client:send("key_pressed", {key=self.mando[4].data})

		elseif self:collides(self.mando[5],x,y) then
			
				if self.t_bala==1 then
					self.t_bala=2 
				else
					self.t_bala=1
				end

		elseif self:collides(self.mando[6],x,y) then
			self.client:send("key_pressed", {key=self.mando[6].data})
		elseif self:collides(self.mando[7],x,y) then
			self.client:send("key_pressed", {key=self.mando[7].data})
		elseif self:collides(self.mando[8],x,y) then
			--transformacion
			self.client:send("key_pressed", {key=self.mando[8].data})
		elseif self:collides(self.mando[9],x,y) then

			pl.z=pl.z+5

			if pl.z>45 then
				pl.z=45
			end

		elseif self:collides(self.mando[10],x,y) then
			
			pl.z=pl.z-5

			if pl.z<0 then
				pl.z=0
			end
		elseif self:collides(self.mando[11],x,y) then
			self.client:disconnect()
		else
			local cx,cy=self.cam:toWorld(x,y)
			self.client:send("mouse_pressed", {x=cx,y=cy,button=self.t_bala})

		end
	end
end

function entidad:touchreleased( id, x, y, dx, dy, pressure )
	if self.client:getState() == "connected" and self.id_player then
		local pl=self.players[self.id_player]

		if self:collides(self.mando[1],x,y) then
			self.client:send("key_released", {key=self.mando[1].data})

		elseif self:collides(self.mando[2],x,y) then
			self.client:send("key_released", {key=self.mando[2].data})

		elseif self:collides(self.mando[3],x,y) then
			self.client:send("key_released", {key=self.mando[3].data})

		elseif self:collides(self.mando[4],x,y) then
			self.client:send("key_released", {key=self.mando[4].data})

		elseif self:collides(self.mando[6],x,y) then
			self.client:send("key_released", {key=self.mando[6].data})

		elseif self:collides(self.mando[7],x,y) then
			self.client:send("key_released", {key=self.mando[7].data})
		else
			local cx,cy=self.cam:toWorld(x,y)
			self.client:send("mouse_released", {x=cx,y=cy,button=self.t_bala})
		end
	end

end

function entidad:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getPosition())
	return cx,cy 
end

function entidad:collides(table,x,y)
	if x> table.mx and x<table.mx+table.mw and y>table.my and y<table.my+table.mh then
		return true
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

return entidad