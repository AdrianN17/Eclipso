local Class = require "libs.hump.class"

local delete = Class{}

function delete:init(table)
  self.name_table=table
end

function delete:remove()
	if self.collider then

    	self.collider:destroy()

    end

	self.entidades:remove_obj(self.name_table,self)
end

return delete