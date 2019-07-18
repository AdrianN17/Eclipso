local Class= require "libs.hump.class"

local entidad_servidor = Class{}



function entidad_servidor:init()

	self.gameobject={}

	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
  	self.gameobject.destruible={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}
  	self.gameobject.arboles={}


  	self.world = love.physics.newWorld(0, 0, false)
  	--self.world:setCallbacks(self:callbacks())
end

function entidad_servidor:draw_entidad()

end

function entidad_servidor:update_entidad(dt)

end

return entidad_servidor