local Class= require "libs.hump.class"
local personajes = {
	aegis = require "entidades.personajes.aegis",
	solange = require "entidades.personajes.solange",
	radian = require "entidades.personajes.radian",
	xeon = require "entidades.personajes.xeon"
}

local entidad_servidor = Class{}



function entidad_servidor:init(personaje)

	self.world = love.physics.newWorld(0, 0, false)
  	self.world:setCallbacks(self:callbacks())

	self.gameobject={}

	self.gameobject.players={}

	self.gameobject.players[0]=personajes[personaje](self,100,100,1)
	self.gameobject.balas={}
	self.gameobject.efectos={}
  	self.gameobject.destruible={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}
  	self.gameobject.arboles={}


  	
end

function entidad_servidor:draw_entidad()

end

function entidad_servidor:update_entidad(dt)

end

function entidad_servidor:callbacks()
	local beginContact =  function(a, b, coll)

		local obj1=nil
 		local obj2=nil

		local o1,o2=a:getUserData(),b:getUserData()

		if o1.pos<o2.pos then
			obj1=o1
			obj2=o2
		else
			obj1=o2
			obj2=o1
		end

 		local x,y=coll:getNormal()
    	
  	end
  
  	local endContact =  function(a, b, coll)
 		local obj1=nil
 		local obj2=nil

		local o1,o2=a:getUserData(),b:getUserData()
    
    	if o1.pos<o2.pos then
			obj1=o1
			obj2=o2
		else
			obj1=o2
			obj2=o1
		end
    
    	local x,y=coll:getNormal()
    
  	end
  
  	local preSolve =  function(a, b, coll)
	    
  	end
  
  	local postSolve =  function(a, b, coll, normalimpulse, tangentimpulse)

	end

	return beginContact,endContact,preSolve,postSolve
end

return entidad_servidor

--el primer jugador, el usado por el dueño del servidor sera 0