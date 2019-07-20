local Class = require "libs.hump.class"

local delete = Class{}

function delete:init(table)
  self.name_table=table
end

function delete:remove()

    self.collider:destroy()

	self.entidades:remove_obj(self.name_table,self)
end

return delete