local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local extras = require "self_libs.extras"

local cliente = Class{}

function cliente:init(ip,puerto,nombre,eleccion)

  self.tickRate = 1/60
  self.tick = 0

	self.client = Sock.newClient(ip, port)
	self.client:setSerialization(bitser.dumps, bitser.loads)

	
  self.client:enableCompression()
  
  
  self.client:setSchema("jugadores", {
        "player_data",
        "balas_data",
        "enemigos_data",
        "objetos_data",
        "arboles_data"
    })

    self.client:on("player_id", function(num)
        self.id_player=num  
        
    end)

    self.client:on("desconexion_player",function(data)
        if self.players[data] then
             self.players[data]=nil
        end
    end)

    self.client:on("remover",function(data)
        if self.players[data] then
            self.players[data]=nil
        end
    end)

    self.client:on("jugadores", function(data)
        local players = data.player_data
        local balas = data.balas_data
        local enemigos = data.enemigos_data
        local objetos = data.objetos_data
        local arboles = data.arboles_data

        if self.id_player then
            
            
            self.players=players
            self.enemigos=enemigos
            self.balas=balas
            self.objetos=objetos
            self.arboles=arboles
            
        end
    end)
  
  self.client:connect(eleccion)
  
  self.spritesheet=img
end

function cliente:client_update(dt)
  self.client:update()
  
  if self.client:getState() == "connected" then
        self.tick = self.tick + dt
    end

    if self.tick >= self.tickRate then
        self.tick = 0

        if self.id_player and self.players[self.id_player] then
            local pl=self.players[self.id_player]
            
            
            self.cam:setPosition(pl.ox,pl.oy)

            pl.rx,pl.ry=self:getXY()
            
            local datos=enviar_data_jugador(pl,"rx","ry")
            datos.cam_x,datos.cam_y,datos.cam_w,datos.cam_h=self.cam:getVisible()
            datos.cam_w=datos.cam_x+datos.cam_w
            datos.cam_h=datos.cam_y+datos.cam_h
            
            self.client:send("datos", datos)
        end
    end
end

function cliente:client_draw()
  local cx,cy,cw,ch=self.cam:getVisible()
  
  self.map:draw(-cx,-cy,1,1)
  
  self.cam:draw(function(l,t,w,h)
        if self.id_player then
          
            for _,objeto in ipairs(self.objetos) do
              local indice_objetos=self.spritesheet.objetos
              local x,y,w,h = indice_objetos[objeto.tipo_indice]:getViewport( )
  
              lg.draw(indice_objetos["image"],indice_objetos[objeto.tipo_indice],objeto.ox,objeto.oy,0,indice_objetos.scale,indice_objetos.scale,w/2,h/2)
            end
            
            for _,enemigo in ipairs(self.enemigos) do
              local area = self.spritesheet[enemigo.tipo_area]
              
              local x,y,w,h = area[enemigo.tipo_indice][enemigo.iterator]:getViewport( )
    
              lg.draw(area["image"],area[enemigo.tipo_indice][enemigo.iterator],enemigo.ox,enemigo.oy,enemigo.radio,area[enemigo.tipo_indice].scale,area[enemigo.tipo_indice].scale,w/2,h/2)
            end


            
            
            
            
            for _,bala in ipairs(self.balas) do
              local indice_balas = self.spritesheet.balas
              
              local x,y,w,h = indice_balas[bala.tipo_indice]:getViewport( )
              
              lg.draw(indice_balas["image"],indice_balas[bala.tipo_indice],bala.ox,bala.oy,0,indice_balas.scale,indice_balas.scale,w/2,h/2)
            end
            
            for _, player in pairs(self.players) do
                if player then
                  local indice = self.spritesheet[player.tipo_indice]
                  local x,y,w,h = indice[player.iterator]:getViewport( )
                  lg.draw(indice["image"],indice[player.iterator],player.ox,player.oy,player.radio + math.pi/2,indice.scale,indice.scale,w/2,h/2)
                end
            end 
            
            for _,arbol in ipairs(self.arboles) do
              local indice_arboles=self.spritesheet.objetos
              local x,y,w,h = indice_arboles[arbol.tipo_indice]:getViewport( )
  
              lg.draw(indice_arboles["image"],indice_arboles[arbol.tipo_indice],arbol.ox,arbol.oy,0,indice_arboles.scale,indice_arboles.scale,w/2,h/2)
            end
            
        end
    end)
  
  lg.print(self.client:getState(), 5, 70)
  lg.print("Ping : " .. self.client:getRoundTripTime(), 200,10)
end

function cliente:keypressed(key)
	 if self.client:getState() == "connected" and self.id_player  then
        if key=="escape" then
             self.client:disconnect()
        else
             local pl=self.players[self.id_player]

             self.client:send("key_pressed", {key=key})
        end
    end
end

function cliente:keyreleased(key)
	if self.client:getState() == "connected" and self.id_player  then
        local pl=self.players[self.id_player]

        self.client:send("key_released", {key=key})
    end
end

function cliente:mousepressed(x,y,button)
     if self.client:getState() == "connected" and self.id_player then
        local cx,cy=self.cam:toWorld(x,y)
        self.client:send("mouse_pressed", {x=cx,y=cy,button=button})
    end
end

function cliente:mousereleased(x,y,button)
    if self.client:getState() == "connected" and self.id_player then
        local cx,cy=self.cam:toWorld(x,y)
        self.client:send("mouse_released", {x=cx,y=cy,button=button})
    end
end

function cliente:quit()
    self.client:disconnect()
end


return cliente