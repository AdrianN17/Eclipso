local Class = require "libs.hump.class"

local modelo_destruccion = Class{}

function modelo_destruccion:init()
  
end

function modelo_destruccion:destroy(table)
  self.collider:destroy()

	self.entidades:remove_to_nill(table,self)
end

return modelo_destruccion
