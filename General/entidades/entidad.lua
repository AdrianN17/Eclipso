local Class = require "libs.hump.class"

local player = {require "entidades.personajes.A", "entidades.personajes.S" , "entidades.personajes.X" , "entidades.personajes.R" , "entidades.personajes.MrH-S" , "entidades.personajes.C"}

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

	--camara
	self.camwiew={}
	self.camwiew.x,self.camwiew.y,self.camwiew.w,self.camwiew.h=self.cam:getWorld()

	self.player=player[eleccion](self,100,100,20)
end

function entidad:draw()
	
	self.cam:draw(function(l,t,w,h)
 		
 		--self.map:draw(0,0)
 		self.player:draw()
	end)


end


function entidad:update(dt)
	self.player:update(dt)
	self.cam:setPosition( self.player.ox, self.player.oy)
end

function entidad:keypressed(key)
	if key=="g" then
		self.cam:setAngle(math.rad(270))
	end

	if key=="f" then
		self.cam:setScale(0.1)
	end

	self.player:keypressed(key)
	
end

function entidad:keyreleased(key)
	self.player:keyreleased(key)
end

function entidad:mousepressed(x,y,button)

end

function entidad:mousereleased(x,y,button)

end


return entidad