local Class = require "libs.hump.class"
local sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"

require "libs.extra.extras"

local entidades=Class{}

local personajes={}

function entidades:init(cam,timer,signal,vector,eleccion)
	self.cam=cam
	self.timer=timer
	self.signal=signal
	self.vector=vector



	personajes={
		require "entidades.personajes.aegis"
	}

	self.entidad={
		players={},
		balas={},
		efectos={},
		enemigos={}
	}



	self.world = love.physics.newWorld(0, 0, false)
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)


	self:add_obj("players",personajes[eleccion](self,100,100,0))





	self.pl=self.entidad.players[1]

end

function entidades:enter()
	
end

function entidades:draw()
	self.cam:draw(function(l,t,w,h)
		for i, obj in pairs(self.entidad) do
			for _, obj2 in ipairs(obj) do
				obj2:draw()
			end
		end

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

function entidades:update(dt)
	self.world:update(dt)

	for i, obj in pairs(self.entidad) do
		for _, obj2 in ipairs(obj) do
			obj2:update(dt)
		end
	end

	self.cam:setPosition(self.pl.ox,self.pl.oy)



end

function entidades:keypressed(key)
	self.pl:keypressed(key)
end

function entidades:keyreleased(key)
	self.pl:keyreleased(key)
end

function entidades:mousepressed(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	self.pl:mousepressed(cx,cy,button)
end

function entidades:mousereleased(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	self.pl:mousereleased(cx,cy,button)
end

function entidades:touchpressed(id,x,y,dx,dy,pressure)
	
end

function entidades:touchreleased(id,x,y,dx,dy,pressure)
	
end

function entidades:add_obj(name,table)

	table.insert(self.entidad[name],table)
end

function entidades:remove_obj(name,table)
	for i, e in ipairs(self.entidad[name]) do
		if e==table then
			table.remove(self.entidad[name],i)
			return
		end
	end
end

function entidades:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())

	return cx,cy
end

function entidades:beginContact(a, b, coll)
 
end
 
function entidades:endContact(a, b, coll)
 
end
 
function entidades:preSolve(a, b, coll)
 
end
 
function entidades:postSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end


return entidades