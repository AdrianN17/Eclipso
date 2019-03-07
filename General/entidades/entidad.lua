local Class = require "libs.hump.class"

local player = {require "entidades.personajes.A", require "entidades.personajes.S" , require "entidades.personajes.X" , require "entidades.personajes.R" , require "entidades.personajes.MrH_S" , require "entidades.personajes.C"}
local HC_collisions= require "libs.HC_collisions.HC_collisions"


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

	--colisiones
	self.collisions=HC_collisions(self.collider)
	--clases de colisiones
	self.collisions:add_collision_class("player")
	self.collisions:add_collision_class("balas")
	self.collisions:add_collision_class("suelo_llamas")
	self.collisions:add_collision_class("campo_electrico")
	self.collisions:add_collision_class("barrera_hielo")

	

	self.collisions:add_collisions_filter_parameter("bala-barrera_hielo","balas","barrera_hielo",function(obj1,obj2) 
		if obj1.name=="bala-hielo" then
			if obj2.scale < 1.50  then
				obj2:resize(1)
				obj1:remove()
			end
			
		elseif obj1.name=="bala-fuego" then
			obj2:remove()
			obj1:remove()
		elseif obj1.name=="bala-electricidad" then
			obj2:attack(obj1.daño)
			obj1:remove()
		end
	end)

	self.collisions:add_collisions_filter_parameter("bala-suelo_llamas","balas","suelo_llamas",function(obj1,obj2)
		if obj1.name=="bala-hielo" then
			obj1:remove()
			obj2:remove()
		end
	end)

	self.collisions:add_collisions_filter_parameter("player-barrera_hielo","player","barrera_hielo","solido")

	self.collisions:add_collisions_filter_parameter("player-balas","player","balas",function(obj1,obj2)
		if obj1.creador ~= obj2.creador then
			
			obj1:attack(obj2.daño)

			if obj2.efecto then
				obj1:efecto(obj2.efecto)
			end

			obj2:remove()

		end
	end)


	self.collisions:add_collisions_filter_parameter("player-balas-protegido","player","balas",function(obj1,obj2,dx,dy)
		if obj1.creador ~= obj2.creador then
			if obj1.estados.protegido then
				if obj1.reflejo then
					obj1:reflejo(obj2,dx,dy)
				else
					obj2:remove()
				end
			end
		end
	end,"escudo")

	self.collisions:add_collisions_filter_parameter("player-suelo_llamas","player","suelo_llamas", function(obj1,obj2)
		obj1:efecto("quemadura",true)
	end)

	self.collisions:add_collisions_filter_parameter("player-campo_electrico","player","campo_electrico", function(obj1,obj2)
		obj1:efecto("paralisis",true)
	end)

	self.collisions:add_collisions_filter_parameter("balas-balas","balas","balas","aniquilar")





	--camara
	self.camwiew={}
	self.camwiew.x,self.camwiew.y,self.camwiew.w,self.camwiew.h=self.cam:getWorld()

	self.player=player[eleccion](self,100,100,1)
	--self.player2=player[1](self,300,300,2)

	self.cam:setScale(0.75)


end

function entidad:draw()
	
	self.cam:draw(function(l,t,w,h)
 		
 		self.collisions:draw()
	end)


end


function entidad:update(dt)
	self.collisions:update(dt)
	self.cam:setPosition( self.player.ox, self.player.oy)
end

function entidad:keypressed(key)
	--[[if key=="g" then
		self.cam:setAngle(math.rad(270))
	end

	if key=="f" then
		self.cam:setScale(0.1)
	end]]

	self.player:keypressed(key)
	
end

function entidad:keyreleased(key)
	self.player:keyreleased(key)
end

function entidad:mousepressed(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	self.player:mousepressed(cx,cy,button)
end

function entidad:mousereleased(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	self.player:mousereleased(cx,cy,button)
end

function entidad:wheelmoved(x,y) 
	self.player:wheelmoved(x,y)
end

function entidad:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getPosition())
	return cx,cy 
end


return entidad