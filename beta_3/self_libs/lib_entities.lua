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

function lib_entities:map_read(objects_map)

  
  for _, layer in ipairs(self.map.layers) do
		if layer.type=="tilelayer" then
			--self:get_tile(layer)
		elseif layer.type=="objectgroup" then
			self:get_objects(layer,objects_map)
		end
	end
end

function lib_entities:get_objects(objectlayer,objects_map)
  
		for _, obj in pairs(objectlayer.objects) do
			objects_map[obj.name](obj.x,obj.y,self)
		end
end

return lib_entities