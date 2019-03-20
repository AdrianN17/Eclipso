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
		require "entidades.personajes.Aegis",
		require "entidades.personajes.Solange",
		require "entidades.personajes.Xeon",
		require "entidades.personajes.Radian",
		require "entidades.personajes.HS",
		require "entidades.personajes.Cromwell",
		
	}

	self.gameobject={}

	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
	self.gameobject.enemigos={}



	self.world = love.physics.newWorld(0, 0, false)


	
    self.world:setCallbacks(self:callbacks())




	self:add_obj("players",personajes[1](self,100,100,1))

	self:add_obj("players",personajes[1](self,200,200,2))

	self.pl=self.gameobject.players[1]

end

function entidades:enter()
	
end

function entidades:draw()
	self.cam:draw(function(l,t,w,h)
		for i, obj in pairs(self.gameobject) do
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

	for i, obj in pairs(self.gameobject) do
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

function entidades:add_obj(name,obj)


	table.insert(self.gameobject[name],obj)
end

function entidades:remove_obj(name,obj)

	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function entidades:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())

	return cx,cy
end

function entidades:callbacks()
	local beginContact =  function(a, b, coll)
 		local obj1=a:getUserData()
 		local obj2=b:getUserData()
 		local x,y=coll:getNormal()

 		--print(obj1.data,obj2.data)

 		if obj1.data=="personaje" and obj2.data=="bala" then
 			if not obj1.obj.estados.protegido  then


	 			obj1.obj:attack(obj2.obj.daño)

	 			if obj2.obj.efecto then
					obj1.obj:efecto(obj2.obj.efecto)
				end

	 			obj2.obj:remove()
	 		end
 		elseif obj1.data=="escudo" and obj2.data=="bala"  then

 			if obj1.obj.estados.protegido  then

 				if obj1.obj.personaje=="Aegis" then
 					obj1.obj:reflejo(obj2.obj,x,y) 
 				else
 					obj2.obj:remove()
 				end
 					
 			end
 		elseif obj1.data=="personaje" and obj2.data=="campo_electrico" then
 			obj1.obj:efecto("paralisis",true)
 		elseif obj1.data=="personaje" and obj2.data=="barrera_de_fuego" then
 			obj1.obj:efecto("quemadura",true)
 		elseif obj1.data=="personaje" and obj2.data=="explosion_plasma" then
 			obj1.obj:efecto("plasma",true)
 		elseif obj1.data=="bala" and obj2.data=="cubo_de_hielo" then
 			if obj1.obj.name=="bala-hielo" then
		 		obj2.obj:resize()
		 		obj1.obj:remove()
	 		elseif obj1.obj.name=="bala-fuego" then
	 			obj2.obj:attack(obj1.obj.daño*2)
	 			obj1.obj:remove()
	 		end
	 	elseif obj1.data=="bala" and obj2.data=="barrera_de_fuego" then
	 		if obj1.obj.name=="bala-hielo" then
	 			obj1.obj:remove()
	 			obj2.obj:remove()
	 		end
 		end
	end


	local endContact =  function(a, b, coll)
 	

	end

	local preSolve =  function(a, b, coll)

		--aqui no va colisiones con fixture
		local obj1=a:getUserData()
 		local obj2=b:getUserData()
 		local x,y=coll:getNormal()

 		
 		if obj1.data=="bala" and obj2.data=="bala" then
 			obj1.obj:collides_bala(obj2.obj)
 			obj2.obj:collides_bala(obj1.obj)
 		end
 
	end

	local postSolve =  function(a, b, coll, normalimpulse, tangentimpulse)
 		
	end

	return beginContact,endContact,preSolve,postSolve
end

return entidades

