local Class= require "libs.hump.class"
local funciones = require "entidades.objetos.funciones_objetos"

local roca = Class{}

function roca:init(entidades,x,y)
	self.tipo="roca"
	self.entidades=entidades

	local poligono = {-62 , -50, -13 , -78, 38 , -67, 73 , -31, 43 , 41, -6 , 79, -58 , 51, -75 , 19}
	
	self.radio=0
	
	funciones:crear_objeto_poligono(self,poligono,x,y)

	self.entidades:add_obj("objetos",self)
end

function roca:update(dt)

end

return roca