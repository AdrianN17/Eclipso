local Class= require "libs.hump.class"
local funciones = require "entidades.objetos.funciones_objetos"

local arbol = Class{}

function arbol:init(entidades,x,y)
	self.tipo="arbol"
	self.entidades=entidades

	self.spritesheet=self.entidades.img_objetos

	self.ox,self.oy=x,y

	self.entidades:add_obj("arboles",self)
end


function arbol:draw()
	funciones:dibujar_objetos(self)
end

function arbol:update(dt)

end

return arbol