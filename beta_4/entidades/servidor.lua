local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local sti = require "libs.sti"

local entidad_servidor = require "entidades.entidad_servidor"

local servidor = Class{
	__includes={entidad_servidor}
}

function servidor:init()
	
end

function servidor:enter(gamestate,nickname,max_jugadores,max_enemigos,personaje,mapas)

	local x,y=lg.getDimensions( )
	self.mapa_files=require ("entidades.mapas." .. mapas)
	self.map=sti(self.mapa_files.mapa)

	self.map:resize(x,y)
	self.cam = gamera.new(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setWindow(0,0,x,y)

	--informacion de servidor
	self.tickRate = 1/60
  	self.tick = 0
  
  	self.server = Sock.newServer("192.168.0.3","22122",max_jugadores)
  	self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:enableCompression()

	--creacion de servidor

	entidad_servidor.init(self,personaje)


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

end

function servidor:update(dt)
	self.tick = self.tick + dt

	if self.tick >= self.tickRate then
        self.tick = 0
        
	    self.server:update(dt)
	    self:update_entidad(dt)
	    
	    self.world:update(dt) 
	    self.map:update(dt)    
	end
end

function servidor:quit()
	self.server:destroy()
end

return servidor