local Class = require "libs.hump.class"

local delete_nil = Class{}

function delete_nil:init()

end

function delete_nil:remove()

  	self.collider:destroy()

  	local posicion = self.entidades:remove_player(self)
  	if self.entidades.server then
  		self.entidades:reiniciar_punto_resureccion(self.identificador_nacimiento_player)
  	
  		self.entidades.server:sendToAll("remover_player", posicion)
  	end

end

function delete_nil:remove_final()
	self.collider:destroy()

	if self.entidades.server then
		self.entidades:reiniciar_punto_resureccion(self.identificador_nacimiento_player)
	end

	
  	self.entidades:remove_player_total(self)
end

return delete_nil
