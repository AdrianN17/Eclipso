local Class = require "libs.hump.class"

local delete = Class{}

function delete:init(table)
  self.name_table=table
end

function delete:remove()
	if self.collider then

    	self.collider:destroy()

    end

    if self.entidades.server and self.name_table=="enemigos" then
    	table.insert(self.entidades.enemigos_eliminados,{index = self.index})
    end

	self.entidades:remove_obj(self.name_table,self)

end

return delete