local Class= require "libs.hump.class"
local funciones = require "entidades.objetos.funciones_objetos"

local estrella = Class{}

function estrella:init(entidades,x,y)
	self.tipo="estrella"
	self.entidades=entidades

	local poligono = {-72 , -21,
-40 , -28,
-25 , -36,
-5 , -65,
6 , -67,
23 , -35,
38 , -26,
70 , -19,
71 , -8,
46 , 18,
42 , 34,
45 , 59,
35 , 68,
3 , 54,
-10 , 51,
-43 , 65,
-53 , 58,
-47 , 26,
-50 , 12,
-73 , -14}

	self.radio=0

	funciones:crear_objeto_poligono(self,poligono,x,y)

	self.entidades:add_obj("objetos",self)
end

function estrella:update(dt)
	
end

return estrella