local Class = require "libs.hump.class"

local HC_collisions = Class{}

function HC_collisions:init(HC)
	self.HC=HC
	self.collisions_class={}
	self.collisions_filter_data={}

 

	self.custom_filter={
		solido = function(obj1,obj2,dx,dy) 
			--obj1 es un objeto movible
			obj1.collider:move(dx,dy)
			obj1.escudo:move(dx,dy)
			for _,point in ipairs(obj1.points) do
		    	point:move(dx,dy)
		    end
		end,

		aniquilar = function(obj1,obj2)
			obj1:remove()
			obj2:remove()
		end

	}
end


function HC_collisions:update(dt)
	self:collisions()

	for i,e in pairs(self.collisions_class) do
		for j,f in ipairs(self.collisions_class[i]) do
			f:update(dt)
		end
	end
end

function HC_collisions:draw()
	for i,e in pairs(self.collisions_class) do
		for j,f in ipairs(self.collisions_class[i]) do
			f:draw()
		end
	end
end

function HC_collisions:collisions()
	for _,data in ipairs(self.collisions_filter_data) do
		self:collisions_filter(data[2],data[3],data[4],data[5],data[6])
	end
end

function HC_collisions:collisions_filter(obj_1,obj_2,funcion,col1,col2)

	if not col1 then
		col1="collider"
	end

	if not col2 then
		col2="collider"
	end

	for _,obj1 in pairs(self.collisions_class[obj_1]) do 
		for _,obj2 in pairs(self.collisions_class[obj_2]) do 
			local coll,dx,dy=obj1[col1]:collidesWith(obj2[col2]) 
			if coll then
				if type(funcion)=="function" then
					funcion(obj1,obj2,dx,dy)
				elseif type(funcion)=="string" then
					self.custom_filter[funcion](obj1,obj2,dx,dy)
				end
			end
		end
	end
end

function HC_collisions:add_collision_class(name)
	self.collisions_class[name]={}
end

function HC_collisions:remove_collision_class(name)

end

function HC_collisions:add_collision_object(name,obj)
	table.insert(self.collisions_class[name],obj)
end

function HC_collisions:remove_collision_object(name,obj)
	for i,e in ipairs(self.collisions_class[name]) do
		if e==obj then
			table.remove(self.collisions_class[name],i)
			return
		end
	end
end

function HC_collisions:add_collisions_filter_parameter(name,obj_1,obj_2,funcion,col1,col2)
	table.insert(self.collisions_filter_data,{name,obj_1,obj_2,funcion,col1,col2})
end

function HC_collisions:remove_collisions_filter_parameter(name)
	for i,e in pairs(self.collisions_filter_data) do
		if e[1]==name then
			table.remove(self.collisions_filter_data,i)
			return
		end
	end
end

function HC_collisions:clear()
	self.collisions_class={}
	self.collisions_filter_data={}
	self.HC:resetHash()
end


return HC_collisions