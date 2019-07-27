local Class= require "libs.hump.class"
local funciones = require "entidades.objetos.funciones_objetos"

local punto_enemigo = Class{}

function punto_enemigo:init(entidades,x,y)
	self.tipo="punto_enemigo"
	self.entidades=entidades

	self.spritesheet=self.entidades.img_objetos

	self.radio=0
	self.ox,self.oy=x,y

	self.entidades:add_obj("inicios",self)
end


function punto_enemigo:draw()
	funciones:dibujar_objetos(self)
end

function punto_enemigo:update(dt)

end

return punto_enemigo