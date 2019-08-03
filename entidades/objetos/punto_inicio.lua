local Class= require "libs.hump.class"
local funciones = require "entidades.objetos.funciones_objetos"

local punto_inicio = Class{}

function punto_inicio:init(entidades,x,y)
	self.tipo="punto_inicio"
	self.entidades=entidades

	self.radio=0
	self.ox,self.oy=x,y

	self.entidades:add_obj("inicios",self)

	self.creacion_players=false
end

function punto_inicio:update(dt)

end

return punto_inicio