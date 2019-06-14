local Class = require "libs.hump.class"

local modelo_destruccion = Class{}

function modelo_destruccion:init(table)
  self.name_table=table
end

function modelo_destruccion:remove()
  self.collider:destroy()
  
  self.entidades.server:sendToAll("remover", self.creador)


	self.entidades:remove_to_nill(self.name_table,self)
end

return modelo_destruccion
