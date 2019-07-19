local Class= require "libs.hump.class"
local polybool = require "libs.polygon.polybool"

local funciones = require "entidades.destruible.funciones_destruible"

local arrecife = Class{}

function arrecife:init(entidades,poligono)
	self.tipo="arrecife"
	self.entidades=entidades

	funciones:crear_destruible(self,poligono)

	self.texturas = self.entidades.img_texturas

	--print(self.texturas.arrecife)

	--funciones:crear_mesh(self,poligono)

	self.entidades:add_obj("destruible",self)

end

function arrecife:draw()
	--funciones:dibujar_texturas(self)
end

function arrecife:update(dt)

end

return arrecife