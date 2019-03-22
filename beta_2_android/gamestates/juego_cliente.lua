local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local timer = require "libs.hump.timer"
require "libs.extra.extras"

local juego_cliente=Class{}

function juego_cliente:init()
	self.eleccion_personaje=_G.detalles.personaje
	self.ip=_G.detalles.ip
	self.port=_G.detalles.port



	self.players={}
	self.extra={}



	self.tickRate = 1/60
    self.tick = 0

	self.client = sock.newClient(self.ip, self.port)
	self.client:setSerialization(bitser.dumps, bitser.loads)

	
    self.client:enableCompression()

    self.client:setSchema("jugadores", {
        "index",
        "player_data",
        "extra_data"
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
        local extra = data.extra_data
        

        if self.id_player and index  then
            
            if not self.players[index] then
                self.players[index]={z=0}
            end

            local pl=self.players[index]

            recibir_data_jugador(player,pl)
            

            if extra then
                self.extra=extra
            end

        end
    end)




    self.cam = gamera.new(0,0,2000,2000)
    local x,y=lg.getDimensions( )
    self.cam:setWindow(0,0,x,y)

    self.cam:setScale(1)

    self.dispositivo=_G.detalles.dispositivo


    self.camwiew={}
	self.camwiew.x,self.camwiew.y,self.camwiew.w,self.camwiew.h=self.cam:getWorld()

    

	self.client:connect(self.eleccion_personaje)
end

function juego_cliente:draw()
    self.cam:draw(function(l,t,w,h)
        if self.id_player then


            for _, player in pairs(self.players) do
                if player then
                    lg.circle("fill" ,player.ox,player.oy,player.r)
                end
            end

            for _,extra in pairs(self.extra) do
                if extra then
                    lg.circle("fill",extra.ox,extra.oy,extra.r)
                end
            end
        end
    end)







    lg.print(self.client:getState(), 5, 70)
    lg.print("Ping : " .. self.client:getRoundTripTime(), 200,10)


end

function juego_cliente:update(dt)
    self.client:update()


    if self.client:getState() == "connected" then
        self.tick = self.tick + dt
    end

    if self.tick >= self.tickRate then
        self.tick = 0

        if self.id_player and self.players[self.id_player] then
            local pl=self.players[self.id_player]

            self.cam:setPosition(pl.ox,pl.oy)

            if self.dispositivo ~= "Android" then
                pl.rx,pl.ry=self:getXY()
            end

            local datos=enviar_data_jugador(pl,"rx","ry","z")
            datos.camx,datos.camy,datos.camw,datos.camh=self.cam:getVisible()
            datos.camw=datos.camx+datos.camw
            datos.camh=datos.camy+datos.camh
            self.client:send("datos", datos)
        end
    end

end



function juego_cliente:keypressed(key)
	 if self.client:getState() == "connected" and self.id_player  then
        if key=="escape" then
             self.client:disconnect()
        else
             local pl=self.players[self.id_player]

             self.client:send("key_pressed", {key=key})
        end
    end
end

function juego_cliente:keyreleased(key)
	if self.client:getState() == "connected" and self.id_player  then
        local pl=self.players[self.id_player]

        self.client:send("key_released", {key=key})
    end
end

function juego_cliente:mousepressed(x,y,button)
     if self.client:getState() == "connected" and self.id_player then
        local cx,cy=self.cam:toWorld(x,y)
        self.client:send("mouse_pressed", {x=cx,y=cy,button=button})
    end
end

function juego_cliente:mousereleased(x,y,button)
    if self.client:getState() == "connected" and self.id_player then
        local cx,cy=self.cam:toWorld(x,y)
        self.client:send("mouse_released", {x=cx,y=cy,button=button})
    end
end

function juego_cliente:touchpressed(id,x,y,dx,dy,pressure)

end

function juego_cliente:touchreleased(id,x,y,dx,dy,pressure)

end

function juego_cliente:wheelmoved(x,y)

end

function juego_cliente:quit()
    self.client:disconnect()
end

function juego_cliente:getXY()
    local cx,cy=self.cam:toWorld(love.mouse.getPosition())
    return cx,cy 
end

return juego_cliente