local Class = require "libs.hump.class"

local lib_entities= Class{}

function lib_entities:init()
  
end

function lib_entities:add_obj(name,obj)


	table.insert(self.gameobject[name],obj)
end

function lib_entities:remove_obj(name,obj)

	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function lib_entities:remove_to_nill(name,obj)
	for i, e in pairs(self.gameobject[name]) do
		if e and e==obj  then
			self.gameobject[name][i]=nil
			return
		end
	end
end

function lib_entities:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())
	return cx,cy
end

return lib_entities