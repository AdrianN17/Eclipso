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
	self.collisions:add_collision_class("melee")
	self.collisions:add_collision_class("balas")
	self.collisions:add_collision_class("suelo_llamas")
	self.collisions:add_collision_class("campo_electrico")
	self.collisions:add_collision_class("barrera_hielo")
	self.collisions:add_collision_class("explosion_plasma")

	

	self.collisions:add_collisions_filter_parameter("bala-barrera_hielo","balas","barrera_hielo",function(obj1,obj2) 
		if obj1.name=="bala-hielo" then
			if obj2.scale < 1.50  then
				obj2:resize(1)
				obj1:remove()
			end
			
		elseif obj1.name=="bala-fuego" then
			obj2:remove()
			obj1:remove()
		elseif obj1.name=="bala-electricidad" or obj1.name=="bala-ectoplasma" or obj1.name=="bala-plasma" or obj1.name=="bala-semilla" or obj1.name=="bala-aguja" then
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
		if obj1.creador ~= obj2.creador and obj2.type~= "bala-ectoplasma" then
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

	self.collisions:add_collisions_filter_parameter("player-suelo_llamas","player","explosion_plasma", function(obj1,obj2)
		obj1:efecto("plasma",true)
	end)


	self.collisions:add_collisions_filter_parameter("balas-balas","balas","balas",function(obj1,obj2)
		if obj1.creador ~= obj2.creador then
			obj1:collides_bala(obj2)
			obj2:collides_bala(obj1)
		end
	end)


	self.collisions:add_collisions_filter_parameter("melee-balas","melee","balas", function(obj1,obj2)
		if obj1.creador ~= obj2.creador and obj1.player.estados.atacando then
			obj2:remove()
		end
	end,"melee_shape")

	self.collisions:add_collisions_filter_parameter("melee-balas","melee","player", function(obj1,obj2)
		if obj1.creador ~= obj2.creador and not obj2.estados.atacado and obj1.player.estados.atacando then
			obj2:attack(obj1.damage)
			obj2.estados.atacado=true
			obj2.timer:after(1,function() obj2.estados.atacado=false end)
		end
	end,"melee_shape")

	self.collisions:add_collisions_filter_parameter("player_escudo-player","player","player", function(obj1,obj2,dx,dy)
		if obj1.creador ~= obj2.creador and obj1.estados.protegido   then
			obj2.collider:move(-dx,-dy)
			obj2.escudo:move(-dx,-dy)
			for _,point in ipairs(obj2.points) do
		    	point:move(-dx,-dy)
		    end

		    if obj2.melee then
		    	obj2.melee:moves(-dx,-dy)
		    end
		end
	end,"escudo")

	self.collisions:add_collisions_filter_parameter("melee-barrera_hielo","melee","barrera_hielo", function(obj1,obj2)
		if obj1.player.estados.atacando then
			obj2:attack(obj1.damage)
			obj1.player.estados.atacando=false
		end 

	end,"melee_shape" )






	--camara
	self.camwiew={}
	self.camwiew.x,self.camwiew.y,self.camwiew.w,self.camwiew.h=self.cam:getWorld()

	self.player=player[eleccion](self,100,100,1)

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
	--self.player:mousereleased(cx,cy,button)
	self.player:mover_todo(cx,cy)
end

function entidad:wheelmoved(x,y) 
	self.player:wheelmoved(x,y)
end

function entidad:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getPosition())
	return cx,cy 
end

function entidad:enviar_data_jugador(obj,...)
	--servidor - cliente
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