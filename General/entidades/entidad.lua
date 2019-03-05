local Class = require "libs.hump.class"

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

end

function entidad:draw()
	self.cam:draw(function(l,t,w,h)
 		
 		self.map:draw(0,0)
 		love.graphics.rectangle("fill", 20, 50, 60, 120 )
	end)


	

end


function entidad:update(dt)
	self.cam:setPosition( 20, 50)
end

function entidad:keypressed(key)
	if key=="g" then
		self.cam:setAngle(math.rad(270))
	end

	if key=="f" then
		self.cam:setScale(0.1)
	end
end

function entidad:keyreleased(key)

end

function entidad:mousepressed(x,y,button)

end

function entidad:mousereleased(x,y,button)

end


return entidad