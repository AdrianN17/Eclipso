local Class = require "libs.hump.class"

local modelo_destruccion_otros = Class{}

function modelo_destruccion_otros:init(table)
  self.name_table=table
end

function modelo_destruccion_otros:remove()

    self.collider:destroy()
    
    


	self.entidades:remove_obj(self.name_table,self)
end

return modelo_destruccion_otros