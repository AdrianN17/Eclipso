local Class = require "libs.hump.class"

local modelo_destruccion = Class{}

function modelo_destruccion:init(table)
  self.name_table=table
end

function modelo_destruccion:remove()
  if self.collider then
    self.collider:destroy()
  end

	self.entidades:remove_to_nill(self.name_table,self)
end

return modelo_destruccion
