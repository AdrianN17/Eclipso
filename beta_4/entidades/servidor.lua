local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local sti = require "libs.sti"
local socket = require "socket"

local extra = require "entidades.funciones.extra"

local entidad_servidor = require "entidades.entidad_servidor"

local personajes = {}

personajes.aegis = require "entidades.personajes.aegis"
personajes.solange = require "entidades.personajes.solange"
personajes.xeon = require "entidades.personajes.xeon"
personajes.radian = require "entidades.personajes.radian"


local servidor = Class{
	__includes={entidad_servidor}
}

function servidor:init()
	
end

function servidor:enter(gamestate,nickname,max_jugadores,max_enemigos,personaje,mapas)

	self.mapa_files=require ("entidades.mapas." .. mapas)
	self.map=sti(self.mapa_files.mapa)

	local x,y=lg.getDimensions( )
	self.map:resize(x,y)
	self.cam = gamera.new(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setWindow(0,0,x,y)

	--creacion de servidor

	entidad_servidor.init(self)

	personajes[personaje](self,100,100,self.id_creador,nickname)
  self:aumentar_id_creador()

	--informacion de servidor
	self.tickRate = 1/60
  self.tick = 0
  
  self.server = Sock.newServer(self:getIP(),22122,max_jugadores)
  self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:enableCompression()

  self.server:setSchema("informacion_primaria",{
    "personaje",
    "nickname"
  })



	self.server:on("connect", function(data, client)
		  local index=client:getIndex()

      local objetos_data,arboles_data,inicios_data = extra:extra_data_fija(self)

      client:send("player_init_data", {index,mapas,objetos_data,arboles_data,inicios_data})

  	end)
  
  	self.server:on("informacion_primaria", function(data, client)
    	local index=client:getIndex()

    	self.gameobject.players[index] = personajes[data.personaje](self,100,100,self.id_creador,data.nickname)
      self:aumentar_id_creador()
  	end)


    self.server:on("disconnect", function(data, client)
      
    	local index =client:getIndex()

    	self:remove_personaje(index)

    	self.server:sendToAll("desconexion_player", (index))
    end)


    self.server:on("datos", function(datos, client)
      	local index = client:getIndex()

      	local pl=self.gameobject.players[index]

      	if pl then
        	extra:recibir_data_jugador(datos,pl)
      	end
    end)

    --callbacks

    self.server:on("mouse_pressed" , function(datos, client)
    	local index = client:getIndex()
      	local pl=self.gameobject.players[index]

      	if pl then
        	pl:mousepressed(datos.x,datos.y,datos.button)
      	end
    end)

    self.server:on("mouse_released" , function(datos, client)
    	local index = client:getIndex()
      	local pl=self.gameobject.players[index]

      	if pl then
        	pl:mousereleased(datos.x,datos.y,datos.button)
      	end
    end)

    self.server:on("key_pressed" , function(datos, client)
    	local index = client:getIndex()
      	local pl=self.gameobject.players[index]

      	if pl then
        	pl:keypressed(datos.key)
      	end
    end)

    self.server:on("key_released" , function(datos, client)
    	local index = client:getIndex()
      	local pl=self.gameobject.players[index]

       	if pl then
        	pl:keyreleased(datos.key)
      	end
    end)

end

function servidor:draw()
	local cx,cy,cw,ch=self.cam:getVisible()

  	self.map:draw(-cx,-cy,1,1)

  	self.cam:draw(function(l,t,w,h)
      
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

  	lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    lg.print("Clientes: "..tostring(self.server:getClientCount()), 10, 30)
    

end

function servidor:update(dt)
	self.tick = self.tick + dt

	if self.tick >= self.tickRate then
        self.tick = 0
        
	    self.server:update(dt)
	    self:update_entidad(dt)
	    
	    self.world:update(dt) 
	    self.map:update(dt)    


	    local player_data={}
    
    
		    for i=0,#self.gameobject.players,1 do 
		      if self.gameobject.players[i] == nil then
		        player_data[i]=nil
		      else
		        player_data[i]=self.gameobject.players[i]:pack()
		      end
		    end

		    local balas_data = extra:extra_data(self)

		    self.server:sendToAll("jugadores", {player_data,balas_data})
		end
end

function servidor:quit()
	self.server:destroy()
end

function servidor:getIP()
  local s = socket.udp()
  s:setpeername("74.125.115.104",80)
  local ip, _ = s:getsockname()
  return ip
end

return servidor