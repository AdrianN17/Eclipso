local Class = require "libs.hump.class"

local delete_nil = Class{}

function delete_nil:init()

end

function delete_nil:remove()
  self.collider:destroy()

  local posicion = self.entidades:remove_to_nill(self)
  
  self.entidades.server:sendToAll("remover", posicion)

end

function delete_nil:remove_final()
	self.entidades:reiniciar_punto_resureccion(self.identificador_nacimiento_player)
	self:remove()
end

return delete_nil
